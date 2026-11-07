import pytest


def pytest_addoption(parser):
    group = parser.getgroup("benchmark")
    group.addoption("--benchmark-disable", action="store_true", default=False)
    group.addoption("--benchmark-skip", action="store_true", default=False)


def pytest_configure(config):
    config.addinivalue_line("markers", "benchmark: mark a test as a benchmark")


def pytest_collection_modifyitems(config, items):
    if config.getoption("--benchmark-skip"):
        skip_benchmarks = pytest.mark.skip(reason="benchmark skipped")
        for item in items:
            if item.get_closest_marker("benchmark"):
                item.add_marker(skip_benchmarks)


class Benchmark:
    def __call__(self, function, *args, **kwargs):
        return function(*args, **kwargs)

    def pedantic(self, function, *, setup=None, args=(), kwargs=None, **_):
        if setup is not None:
            setup()
        return function(*args, **(kwargs or {}))


@pytest.fixture
def benchmark():
    return Benchmark()
