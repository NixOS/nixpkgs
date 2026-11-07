import unittest


class TestSelection(unittest.TestCase):
    def test_good(self):
        pass

    def test_bad(self):
        self.fail("ohno")

    def test_2_bad(self):
        self.fail("ohno 2")
