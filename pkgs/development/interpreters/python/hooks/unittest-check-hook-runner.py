# Run `python -m unittest` with matching test methods deselected.
#
# Usage: python unittest-check-hook-runner.py [PATTERN ...] -- [UNITTEST_ARG ...]
#
# PATTERNs share the semantics of `python -m unittest -k`:
# - A pattern without `*` is matched as a sub-string
# - Matching is performed with `fnmatch.fnmatchcase`
#   against the fully qualified test method name (`module.Class.test_method`)
#
# `python -m unittest -k` provides no negation,
# so the deselection happens in a custom test loader instead.

import fnmatch
import os
import sys
import unittest


def convert_pattern(pattern):
    # Mirror unittest.main._convert_select_pattern
    if "*" not in pattern:
        pattern = "*{}*".format(pattern)
    return pattern


class DeselectingTestLoader(unittest.TestLoader):
    def __init__(self, deselect_patterns):
        super().__init__()
        self.deselect_patterns = deselect_patterns

    def getTestCaseNames(self, testCaseClass):
        test_case_names = []
        # super().getTestCaseNames() handles the `-k` flag used to implement `enabledTests`.
        for name in super().getTestCaseNames(testCaseClass):
            # Same as how unittest.TestLoader matches against testNamePatterns
            full_name = "{}.{}.{}".format(
                testCaseClass.__module__, testCaseClass.__qualname__, name
            )
            if any(
                fnmatch.fnmatchcase(full_name, pattern)
                for pattern in self.deselect_patterns
            ):
                print(
                    "unittestCheckHook: deselected {}".format(full_name),
                    file=sys.stderr,
                )
                continue
            test_case_names.append(name)
        return test_case_names


def main():
    try:
        separator = sys.argv.index("--", 1)
    except ValueError:
        sys.exit(
            "ERROR: unittestCheckHook: expect `--` between deselection patterns and unittest arguments."
        )
    patterns = sys.argv[1:separator]
    if not all(patterns):
        sys.exit("ERROR: unittestCheckHook: disabledTests: got an empty element.")

    # Mimic `python -m unittest`
    # `sys.path` prepending:
    # * `python -m`: CWD
    # * `python /path/to/python_script.py`: `/path/to`
    # * Safe path mode (`-P`/PYTHONSAFEPATH, Python >= 3.11): No prepending
    # * Isolated mode (`-I`): No prepending
    # So replace `/path/to` with CWD if present.
    if not (getattr(sys.flags, "safe_path", False) or sys.flags.isolated):
        sys.path[0] = os.getcwd()
    # `unittest.main` is another way to say `unittest.TestProgram`.
    # See unittest/main.py for its __init__() parameters
    # and unittest/__main__.py for its default invocation.
    # https://github.com/python/cpython/blob/refs/tags/v3.13.0/Lib/unittest/main.py
    # https://github.com/python/cpython/blob/refs/tags/v3.13.0/Lib/unittest/__main__.py
    unittest.main(
        module=None,
        argv=[os.path.basename(sys.executable) + " -m unittest"]
        + sys.argv[separator + 1 :],
        testLoader=DeselectingTestLoader([convert_pattern(p) for p in patterns]),
    )


if __name__ == "__main__":
    main()
