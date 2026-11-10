import pytest

from .fixture import BenchmarkFixture


class BenchmarkHooks:
    @pytest.hookspec
    def pytest_benchmark_update_json(self, config, benchmarks, output_json):
        pass

    @pytest.hookspec
    def pytest_benchmark_update_machine_info(self, config, machine_info):
        pass


def pytest_addhooks(pluginmanager):
    pluginmanager.add_hookspecs(BenchmarkHooks)


def pytest_addoption(parser):
    group = parser.getgroup("benchmark")

    for option, default in [
        ("--benchmark-min-time", "0.000005"),
        ("--benchmark-max-time", "1.0"),
        ("--benchmark-min-rounds", "5"),
        ("--benchmark-precision", None),
        ("--benchmark-confidence", "0.99"),
        ("--benchmark-timer", None),
        ("--benchmark-calibration-precision", "10"),
        ("--benchmark-warmup-iterations", "100000"),
        ("--benchmark-save", None),
        ("--benchmark-json", None),
        ("--benchmark-cprofile", None),
        ("--benchmark-cprofile-loops", "1"),
        ("--benchmark-cprofile-top", "25"),
        ("--benchmark-sort", "min"),
        ("--benchmark-group-by", "group"),
        ("--benchmark-columns", None),
        ("--benchmark-name", "normal"),
        ("--benchmark-time-unit", None),
        ("--benchmark-storage", "file://./.benchmarks"),
    ]:
        group.addoption(option, metavar="VALUE", default=default)

    for option in [
        "--benchmark-disable",
        "--benchmark-skip",
        "--benchmark-enable",
        "--benchmark-only",
        "--benchmark-save-data",
        "--benchmark-disable-gc",
        "--benchmark-verbose",
        "--benchmark-quiet",
    ]:
        group.addoption(option, action="store_true", default=False)

    group.addoption("--benchmark-warmup", nargs="?", const="auto", default="auto")
    group.addoption("--benchmark-netrc", nargs="?", const="~/.netrc", default="")
    group.addoption("--benchmark-autosave", action="store_const", const=True)
    group.addoption("--benchmark-compare", nargs="?", const=True, default=[])
    group.addoption("--benchmark-compare-fail", nargs="+")
    group.addoption(
        "--benchmark-cprofile-dump",
        action="append",
        nargs="?",
        const="benchmark",
        default=[],
    )
    group.addoption("--benchmark-histogram", action="append", nargs="?", const="benchmark", default=[])


def pytest_configure(config):
    config.addinivalue_line("markers", "benchmark: mark a test as a benchmark")


def pytest_collection_modifyitems(config, items):
    if config.getoption("--benchmark-skip"):
        skip_benchmarks = pytest.mark.skip(reason="benchmark skipped")
        for item in items:
            if item.get_closest_marker("benchmark"):
                item.add_marker(skip_benchmarks)


@pytest.fixture
def benchmark():
    return BenchmarkFixture()
