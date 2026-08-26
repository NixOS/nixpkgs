#!/usr/bin/env python3

# Builds the FPGA bitstreams `cynthion flash` needs, one set per revision, into
# assets/<CynthionPlatformRevXDY>/{analyzer,facedancer,selftest}.bit

import asyncio
import inspect
import logging
import os
import sys
from pathlib import Path

import cynthion.gateware.platform

logging.basicConfig(level=logging.INFO, format="%(asctime)s:%(name)32s:%(message)s")

logger = logging.getLogger("build-gateware")

BITSTREAMS = ["analyzer", "facedancer", "selftest"]

# Pin the nextpnr placer seed so place-and-route is deterministic. Some
# bitstreams (e.g. CynthionPlatformRev1D3/analyzer) are marginal on timing, and
# without a fixed seed a build can non-deterministically miss the constraint.
NEXTPNR_SEED = 0


async def build_bitstream(
    semaphore: asyncio.Semaphore, assets_dir: Path, platform: str, bitstream: str
) -> None:
    async with semaphore:
        log = logging.getLogger(f"build-gateware.{platform}.{bitstream}")
        log.info("build started")

        env = os.environ.copy()
        env["LUNA_PLATFORM"] = f"cynthion.gateware.platform:{platform}"
        env["AMARANTH_nextpnr_opts"] = f"--seed {NEXTPNR_SEED}"

        out_dir = assets_dir / platform
        out_dir.mkdir(parents=True, exist_ok=True)
        out_path = out_dir / f"{bitstream}.bit"

        process = await asyncio.create_subprocess_exec(
            sys.executable,
            "-m",
            f"cynthion.gateware.{bitstream}.top",
            "--output",
            str(out_path),
            env=env,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.STDOUT,
        )

        stdout, _ = await process.communicate()
        log.info("\n%s", stdout.decode("utf-8", errors="replace"))

        if process.returncode != 0:
            raise RuntimeError(
                f"{platform}/{bitstream} failed with exit code {process.returncode}"
            )
        log.info("build complete")


def collect_platforms() -> set[str]:
    platforms = {
        name
        for name, obj in inspect.getmembers(cynthion.gateware.platform)
        if inspect.isclass(obj) and name.startswith("CynthionPlatform")
    }

    # Allow restricting the set of platforms during development/CI, e.g.
    #   BUILD_GATEWARE_PLATFORMS="CynthionPlatformRev1D4"
    only = os.getenv("BUILD_GATEWARE_PLATFORMS")
    if only:
        requested = set(only.split())
        unknown = requested - platforms
        if unknown:
            raise ValueError(f"unknown platform(s): {', '.join(sorted(unknown))}")
        platforms = requested

    return platforms


async def main() -> int:
    assets_dir = Path(sys.argv[1])
    max_workers = int(os.getenv("BUILD_GATEWARE_MAX_WORKERS") or 1)

    platforms = collect_platforms()
    logger.info(
        "Building %d bitstream(s) for platforms: %s",
        len(platforms) * len(BITSTREAMS),
        ", ".join(sorted(platforms)),
    )

    semaphore = asyncio.Semaphore(max_workers)
    logger.info("Building gateware with %d workers", max_workers)

    results = await asyncio.gather(
        *(
            build_bitstream(semaphore, assets_dir, platform, bitstream)
            for platform in sorted(platforms)
            for bitstream in BITSTREAMS
        ),
        return_exceptions=True,
    )

    failures = [r for r in results if isinstance(r, BaseException)]
    for failure in failures:
        logger.error(failure)
    return 1 if failures else 0


sys.exit(asyncio.run(main()))
