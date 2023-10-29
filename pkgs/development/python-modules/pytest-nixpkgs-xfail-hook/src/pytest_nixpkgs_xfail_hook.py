import sys, os, pytest, importlib
from _pytest.runner import pytest_runtest_makereport
if sys.version_info >= (3, 4):
    import importlib.util

# format: importable.module:object.attr
# inspired by https://packaging.python.org/en/latest/specifications/entry-points/

DEFAULT_XFAIL_ENDPOINTS = [
    # touches network
    "aiohttp:ClientSession._request",
    "asyncio.base_events:BaseEventLoop._create_connection_transport",
    #"asyncio.base_events:BaseEventLoop.create_connection",
    #"asyncio:open_connection",
    "httpx:AsyncClient.get",
    "httpx:AsyncClient.head",
    "httpx:Request",
    "requests:get",
    "requests:head",
    "requests:post",
    "socket:create_connection",
    "socket:socket.connect",
    "urllib.request:Request",
    "urllib.request:urlopen",
    "urllib3.connection:HTTPConnection._new_conn",
    "urllib3.connection:HTTPSConnection._new_conn",
    "websockets:connect",
]

DEFAULT_XFAIL_EXCEPTIONS = [
    # touched network
    #""
    #"httpx:ConnectError"
]

if "pytestXfailEndpoints" in os.environ:
    DEFAULT_XFAIL_ENDPOINTS.clear()
if "pytestXfailExceptions" in os.environ:
    DEFAULT_XFAIL_EXCEPTIONS.clear()

XFAIL_ENDPOINTS = DEFAULT_XFAIL_ENDPOINTS \
    + os.environ.get("pytestXfailEndpoints", "").split() \
    + os.environ.get("pytestExtraXfailEndpoints", "").split()
XFAIL_EXCEPTIONS = DEFAULT_XFAIL_EXCEPTIONS \
    + os.environ.get("pytestXfailExceptions", "").split() \
    + os.environ.get("pytestExtraXfailExceptions", "").split()

NotAvailable = object()


def import_object(module: str, *attrpath: str, is_default: bool):
    try:
        if sys.version_info >= (3, 4):
            if importlib.util.find_spec(module) is None:
                raise ModuleNotFoundError(module)
        item = importlib.import_module(module)
    except (ModuleNotFoundError, ImportError):
        if is_default:
            return NotAvailable
        else:
            raise

    for i, part in enumerate(attrpath):
        assert hasattr(item, part), f"{module}:{'.'.join(attrpath[:i])} has no member {part!r}"
        item = getattr(item, part)
    return item


# fail early, before pytest captures errors
for endpoint in XFAIL_ENDPOINTS:
    module, sep, attr = endpoint.partition(":")
    assert module, f"Not a valid endpoint: {endpoint!r} (Missing module)"
    assert sep,    f"Not a valid endpoint: {endpoint!r} (Missing : delimiter)"
    assert attr,   f"Not a valid endpoint: {endpoint!r} (Missing attribute)"
    import_object(module, *attr.split("."), is_default=endpoint in DEFAULT_XFAIL_ENDPOINTS)


@pytest.fixture(scope="session", autouse=True)
def stub_xfail_endpoints():
    def mk_xfail_endpoint(endpoint: str):
        def raise_xfail(*a, **kw):
            # RFC: should we log *a and **kw?
            pytest.xfail(f"{endpoint=} is expected to fail in nixpkgs sandbox")
        return raise_xfail

    for endpoint in XFAIL_ENDPOINTS:
        module, sep, attr = endpoint.partition(":")
        *attrpath, attr = attr.split(".")
        item = import_object(module, *attrpath, is_default=endpoint in DEFAULT_XFAIL_ENDPOINTS)
        if item is NotAvailable:
            continue

        assert hasattr(item, attr), f"{module}:{'.'.join(attrpath)} has no member {attr!r}"
        setattr(item, attr, mk_xfail_endpoint(endpoint))

    yield


# dereference the exceptions ahead of time
XFAIL_EXCEPTION_REFERENCES = {}
for endpoint in XFAIL_EXCEPTIONS:
    module, sep, attr = endpoint.partition(":")
    assert module, f"Not a valid endpoint: {endpoint!r} (Missing module)"
    assert sep,    f"Not a valid endpoint: {endpoint!r} (Missing : delimiter)"
    assert attr,   f"Not a valid endpoint: {endpoint!r} (Missing attribute)"
    exc_cls = import_object(module, *attr.split("."), is_default=endpoint in DEFAULT_XFAIL_EXCEPTIONS)
    if exc_cls is NotAvailable:
        continue

    assert issubclass(exc_cls, BaseException), f"{endpoint} is not an exception: {exc_cls!r}"
    XFAIL_EXCEPTION_REFERENCES[endpoint] = exc_cls


def pytest_runtest_makereport(item, call, *, _orig=pytest_runtest_makereport):
    """
    Modifies test results after-the-fact. The function name is magic.
    https://docs.pytest.org/en/7.1.x/reference/reference.html?highlight=pytest_runtest_makereport#std-hook-pytest_runtest_makereport
    """

    def iterate_exc_chain(exc: Exception):
        "Yields all exceptions in exception chain"
        yield exc
        if getattr(exc, "__context__", None) is not None:
            yield from iterate_exc_chain(exc.__context__)
        if getattr(exc, "__cause__", None) is not None:
            yield from iterate_exc_chain(exc.__cause__)

    tr = _orig(item, call)
    if call.excinfo is not None:
        for exc in iterate_exc_chain(call.excinfo.value):
            for endpoint, xfailed_exc_cls in XFAIL_EXCEPTION_REFERENCES.items():
                if isinstance(exc, xfailed_exc_cls):
                    tr.outcome = "skipped"
                    tr.wasxfail = f"reason: {endpoint=} is an expected failure in nixpkgs sandbox"
    return tr
