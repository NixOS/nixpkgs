#!/usr/bin/env python3
"""
relax or remove dependencies specified in a wheel METADATA file.
"""

import email.message
import email.parser
import email.policy
import sys
from argparse import ArgumentParser

from packaging.metadata import Metadata, parse_email
from packaging.specifiers import Specifier, SpecifierSet

argparser = ArgumentParser()
argparser.add_argument(
    "metadata", help="Path to the wheel METADATA file to relax"
)
argparser.add_argument(
    "-o", "--output", default=None, help="Where to write the relaxed METADATA file"
)
argparser.add_argument(
    "-i", "--in-place", action="store_true", help="Modify the relaxed METADATA in place"
)
argparser.add_argument(
    "--print", action="store_true", help="Print the relaxed METADATA file"
)
argparser.add_argument(
    "--relax-all", action="store_true", help="Relax all version constraints"
)
argparser.add_argument(
    "--remove-all", action="store_true", help="Remove all dependencies"
)
argparser.add_argument(
    "--relax",
    action="append",
    default=[],
    help="Which dependency to relax, can be provided multiple times",
)
argparser.add_argument(
    "--remove",
    action="append",
    default=[],
    help="Which dependency to remove, can be provided multiple times",
)
argparser.add_argument(
    "--relax-upper-only", action="store_true", help="Relax upper version constraints"
)


if __name__ == "__main__":
    args = argparser.parse_args()

    # open and parse wheel METADATA file:
    with open(args.metadata, "rb") as fd:
        metadata_bytes = fd.read()

    metadata_raw_fields, _ = parse_email(metadata_bytes)
    metadata = Metadata.from_raw(metadata_raw_fields)

    # iterate through the "Requires-Dist" entries and either remove or relax them
    new_requires_dist = []
    for requirement in metadata.requires_dist:
        # remove
        if args.remove_all or requirement.name in args.remove:
            continue

        # relax
        if args.relax_all or requirement.name in args.relax:

            # relax all version constraints
            if not args.relax_upper_only:
                requirement.specifier = None

            # relax upper version constraints, if any
            elif requirement.specifier:
                new_specifier_set = []
                for specifier in requirement.specifier:
                    if specifier.operator in (">", ">="):
                        # keep
                        new_specifier_set.append(specifier)
                    elif specifier.operator in ("~=", "=="):
                        # relax
                        new_specifier_set.append(Specifier(f">={specifier.version}"))
                    elif specifier.operator in ("!=", "<=", "<", "==="):
                        # remove
                        pass
                    else:
                        # packaging.specifiers.Specifier should raise packaging.specifiers.InvalidSpecifier in this case
                        assert False, f"unknown specifier operator: {specifier.operator!r}"
                requirement.specifier = SpecifierSet(
                    ",".join(sorted(str(s) for s in new_specifier_set))
                )

        new_requires_dist.append(requirement)

    metadata.requires_dist = new_requires_dist

    # parse and generate bytes to avoid mangling fields
    metadata_parser = email.parser.BytesParser(policy=email.policy.compat32.clone(max_line_length=None))
    metadata_parsed: email.message.Message = metadata_parser.parsebytes(metadata_bytes)

    # drop all "Requires-Dist" headers and append the modified ones
    del metadata_parsed["Requires-Dist"]
    for requirement in metadata.requires_dist:
        metadata_parsed.set_raw("Requires-Dist", str(requirement))

    if args.print:
        # print(metadata_parsed.as_bytes().decode())
        sys.stdout.buffer.write(metadata_parsed.as_bytes())
        sys.stdout.buffer.sync()

    if args.output or args.in_place:
        with open(args.metadata if args.in_place else args.output, "wb") as fd:
            fd.write(metadata_parsed.as_bytes())
