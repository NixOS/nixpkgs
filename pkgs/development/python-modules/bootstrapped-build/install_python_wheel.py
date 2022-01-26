
"""Script for installing Python packages using the installer API when a prefix is needed.

Based on https://github.com/pradyunsg/installer/commit/777a499d5a351c07a631147c96e41db8cdfdbcfc.
"""

import argparse
import os.path
import sys
import sysconfig
from typing import Dict, Optional, Sequence

import installer
import installer.destinations
import installer.sources
import installer.utils


def main_parser() -> argparse.ArgumentParser:
    """Construct the main parser."""
    parser = argparse.ArgumentParser()
    parser.add_argument("wheel", type=str, help="wheel file to install")
    parser.add_argument(
        "--destdir",
        "-d",
        metavar="path",
        type=str,
        help="destination directory",
    )
    parser.add_argument(
        "--prefix",
        metavar="path",
        type=str,
        help="prefix directory",
    )
    parser.add_argument(
        "--prefix-to-remove",
        metavar="path",
        type=str,
        help="prefix directory to remove",
    )
    parser.add_argument(
        "--compile-bytecode",
        action="append",
        metavar="level",
        type=int,
        choices=[0, 1, 2],
        help="generate bytecode for the specified optimization level(s) (default=0, 1)",
    )
    parser.add_argument(
        "--no-compile-bytecode",
        action="store_true",
        help="don't generate bytecode for installed modules",
    )
    return parser


def get_scheme_dict(distribution_name: str) -> Dict[str, str]:
    """Calculate the scheme dictionary for the current Python environment."""
    scheme_dict = sysconfig.get_paths()

    # calculate 'headers' path, not currently in sysconfig - see
    # https://bugs.python.org/issue44445. This is based on what distutils does.
    # TODO: figure out original vs normalised distribution names
    scheme_dict["headers"] = os.path.join(
        sysconfig.get_path(
            "include", vars={"installed_base": sysconfig.get_config_var("base")}
        ),
        distribution_name,
    )

    return scheme_dict


def prefix_scheme_dict(scheme: Dict[str, str], prefix: str, prefix_to_remove: str):
    """Replace the existing prefix with the new prefix"""
    # Cannot use os.path.commonpath because there can be items in the scheme that
    # consist of only the prefix and nothing more.
    replace_prefix = lambda path: path.replace(prefix_to_remove, prefix)
    new_scheme = {key: replace_prefix(path) for key, path in scheme.items()}
    return new_scheme


def main(cli_args: Sequence[str], program: Optional[str] = None) -> None:
    """Process arguments and perform the install."""
    parser = main_parser()
    if program:
        parser.prog = program
    args = parser.parse_args(cli_args)

    bytecode_levels = args.compile_bytecode
    if args.no_compile_bytecode:
        bytecode_levels = []
    elif not bytecode_levels:
        bytecode_levels = [0, 1]

    with installer.sources.WheelFile.open(args.wheel) as source:
        destination = installer.destinations.SchemeDictionaryDestination(
            prefix_scheme_dict(get_scheme_dict(source.distribution), args.prefix, args.prefix_to_remove),
            sys.executable,
            installer.utils.get_launcher_kind(),
            bytecode_optimization_levels=bytecode_levels,
            destdir=args.destdir,
        )
        installer.install(source, destination, {})


if __name__ == "__main__":  # pragma: no cover
    main(sys.argv[1:], "python -m installer")