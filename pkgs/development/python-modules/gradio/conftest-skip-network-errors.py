# This is a pytest hook that skips tests that tries to access the network.
# These tests will immediately fail, then get marked as "Expected fail" (xfail).

from _pytest.runner import pytest_runtest_makereport as orig_pytest_runtest_makereport

# We use BaseException to minimize the chance it gets caught and 'pass'ed
class NixNetworkAccessDeniedError(BaseException):
    pass

def pytest_runtest_makereport(item, call):
    """
    Modifies test results after-the-fact. The function name is magic, see:
    https://docs.pytest.org/en/7.1.x/reference/reference.html?highlight=pytest_runtest_makereport#std-hook-pytest_runtest_makereport
    """

    def iterate_exc_chain(exc: Exception):
        """
        Recurses through exception chain, yielding all exceptions
        """
        yield exc
        if getattr(exc, "__context__", None) is not None:
            yield from iterate_exc_chain(exc.__context__)
        if getattr(exc, "__cause__", None) is not None:
            yield from iterate_exc_chain(exc.__cause__)

    tr = orig_pytest_runtest_makereport(item, call)
    if call.excinfo is not None:
        for exc in iterate_exc_chain(call.excinfo.value):
            if isinstance(exc, NixNetworkAccessDeniedError):
                tr.outcome, tr.wasxfail = 'skipped', "reason: Requires network access."
            if isinstance(exc, socket.gaierror):
                tr.outcome, tr.wasxfail = 'skipped', "reason: Requires network access."
            if isinstance(exc, httpx.ConnectError):
                tr.outcome, tr.wasxfail = 'skipped', "reason: Requires network access."
            if isinstance(exc, FileNotFoundError):  # gradio specific
                tr.outcome, tr.wasxfail = 'skipped', "reason: Pypi dist bad."
    return tr

# replace network access with exception

def deny_network_access(*a, **kw):
    raise NixNetworkAccessDeniedError

import httpx
import requests
import socket
import urllib
import urllib3
import websockets

httpx.AsyncClient.get = deny_network_access
httpx.AsyncClient.head = deny_network_access
httpx.Request = deny_network_access
requests.get = deny_network_access
requests.head = deny_network_access
requests.post = deny_network_access
socket.socket.connect = deny_network_access
urllib.request.Request = deny_network_access
urllib.request.urlopen = deny_network_access
urllib3.connection.HTTPSConnection._new_conn = deny_network_access
websockets.connect = deny_network_access
