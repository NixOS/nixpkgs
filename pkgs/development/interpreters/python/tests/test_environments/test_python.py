"""
Python interpreter and environment tests.

These need to be executed with the standard library unittest.
Third party test runners such as pytest cannot be used because
that would interfere with the tests.
"""

import platform
import sys
import unittest
import site


ENV = "@env@"
INTERPRETER = "@interpreter@"
PYTHON_VERSION = "@pythonVersion@"

IS_VIRTUALENV = @is_virtualenv@
IS_VENV = @is_venv@
IS_NIXENV = @is_nixenv@
IS_PYPY = platform.python_implementation() == "PyPy"


class TestCasePython(unittest.TestCase):

    @unittest.skipIf(IS_PYPY, "Executable is incorrect and needs to be fixed.")
    def test_interpreter(self):
        self.assertEqual(sys.executable, INTERPRETER)

    @unittest.skipIf(IS_PYPY, "Prefix is incorrect and needs to be fixed.")
    def test_prefix(self):
        self.assertEqual(sys.prefix, ENV)
        self.assertEqual(sys.prefix, sys.exec_prefix)

    def test_site_prefix(self):
        self.assertTrue(sys.prefix in site.PREFIXES)

    @unittest.skipIf(IS_PYPY or sys.version_info.major==2, "Python 2 does not have base_prefix")
    def test_base_prefix(self):
        if IS_VENV or IS_NIXENV or IS_VIRTUALENV:
            self.assertNotEqual(sys.prefix, sys.base_prefix)
        else:
            self.assertEqual(sys.prefix, sys.base_prefix)

    @unittest.skipIf(sys.version_info.major==3, "sys.real_prefix is only set by virtualenv in case of Python 2.")
    def test_real_prefix(self):
        self.assertTrue(hasattr(sys, "real_prefix") == IS_VIRTUALENV)

    def test_python_version(self):
        self.assertTrue(platform.python_version().startswith(PYTHON_VERSION))


if __name__ == "__main__":
    unittest.main()
