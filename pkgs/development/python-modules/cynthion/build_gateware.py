#!/usr/bin/env python3

import asyncio
import cynthion.gateware.platform
import inspect
import logging
import os
from pathlib import Path
import sys

logging.basicConfig(level=logging.INFO, format="%(asctime)s:%(name)32s:%(message)s")

logger = logging.getLogger("build-gateware")

async def build_bitstream(semaphore: asyncio.Semaphore, assets_dir: Path, platform: str, bistream: str) -> str:
    async with semaphore:
        logger = logging.getLogger(f"build-gateware.{platform}.{bistream}")
        logger.info(f"build started")

        env = os.environ.copy()
        env["LUNA_PLATFORM"] = f"cynthion.gateware.platform:{platform}"

        out_dir = assets_dir / platform
        out_path = out_dir / f"{bistream}.bit"
        out_dir.mkdir(parents=True, exist_ok=True)

        process = await asyncio.create_subprocess_exec(
            "python",
            "-m",
            f"cynthion.gateware.{bistream}.top",
            "--output",
            str(out_path),
            env=env,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )

        stdout, stderr = await process.communicate()
        try:
            logger.info(stdout.decode('utf-8'))
            logger.info(stderr.decode('utf-8'))
        except UnicodeDecodeError:
            logger.info(stdout)
            logger.info(stderr)

        if process.returncode != 0:
            logger.error(f"build failed with exit code {process.returncode}")
            raise ValueError(f"Process return code {process.returncode}")
            sys.exit(1)
        logger.info("build complete")

async def main():
    assets_dir = Path(sys.argv[1])
    max_workers = int(os.getenv("BUILD_GATEWARE_MAX_WORKERS")) or 1
    luna_platforms = set()
    bitstreams = ["analyzer", "facedancer", "selftest"]

    # collect the platforms we need to build
    for name, obj in inspect.getmembers(cynthion.gateware.platform):
        if inspect.isclass(obj):
            luna_platforms.add(name)

    print(luna_platforms)
    # remove known-broken platforms
    # Fails to meet timing
    # https://github.com/greatscottgadgets/cynthion/issues/253
    luna_platforms.remove("CynthionPlatformRev0D3")
    # dm_chrip resource not defined for these platforms
    # https://github.com/greatscottgadgets/cynthion/issues/252
    luna_platforms.remove("CynthionPlatformRev0D6")
    luna_platforms.remove("CynthionPlatformRev0D7")
    luna_platforms.remove("CynthionPlatformRev1D0")
    luna_platforms.remove("CynthionPlatformRev1D1")
    luna_platforms.remove("CynthionPlatformRev1D2")
    luna_platforms.remove("CynthionPlatformRev1D3")

    logger.info(f"Building gateware with {max_workers} workers")
    semaphore = asyncio.Semaphore(max_workers)

    results = await asyncio.gather(*[
        build_bitstream(semaphore, assets_dir, platform, bitstream)
        for platform in luna_platforms for bitstream in bitstreams
    ], return_exceptions=True)

    for result in results:
        if result is not None:
            logger.error(result)
            return 1
    return 0

sys.exit(asyncio.run(main()))
