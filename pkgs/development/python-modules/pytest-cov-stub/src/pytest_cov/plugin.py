import argparse
import pytest

class CoverageError(Exception):
    pass

class PytestCovWarning(pytest.PytestWarning):
    pass

class CovDisabledWarning(PytestCovWarning):
    pass

class CovReportWarning(PytestCovWarning):
    pass

class StoreReport(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        report_type, file = values
        namespace.cov_report[report_type] = file

def pytest_addoption(parser):
    group = parser.getgroup('cov', 'coverage reporting')
    group.addoption(
        '--cov',
        action='append',
        default=[],
        metavar='SOURCE',
        nargs='?',
        const=True,
        dest='cov_source',
    )
    group.addoption(
        '--cov-reset',
        action='store_const',
        const=[],
        dest='cov_source',
    )
    group.addoption(
        '--cov-report',
        action=StoreReport,
        default={},
        metavar='TYPE',
        type=lambda x: x.split(":", 1) if ":" in x else (x, None),
    )
    group.addoption(
        '--cov-config',
        action='store',
        default='.coveragerc',
        metavar='PATH',
    )
    group.addoption(
        '--no-cov-on-fail',
        action='store_true',
        default=False,
    )
    group.addoption(
        '--no-cov',
        action='store_true',
        default=False,
    )
    group.addoption(
        '--cov-fail-under',
        action='store',
        metavar='MIN',
        type=str,
    )
    group.addoption(
        '--cov-append',
        action='store_true',
        default=False,
    )
    group.addoption(
        '--cov-branch',
        action='store_true',
        default=None,
    )
    group.addoption(
        '--cov-context',
        action='store',
        metavar='CONTEXT',
        type=str,
    )

def pytest_configure(config):
    config.addinivalue_line('markers', 'no_cover: disable coverage for this test.')

@pytest.fixture
def no_cover():
    pass

@pytest.fixture
def cov():
    pass
