{ lib
, buildPythonPackage
, fetchFromGitHub
, git
, poetry-core
, attrs
, future
, aiohttp
, aiohttp-socks
, aiofiles
, h11
, h2
, Logbook
, jsonschema
, unpaddedbase64
, pycryptodome
, python-olm
, peewee
, cachetools
, atomicwrites
, pytestCheckHook
, faker
, aioresponses
, hypothesis
, pytest-aiohttp
, pytest-benchmark
}:

buildPythonPackage rec {
  pname = "matrix-nio";
  version = "0.18.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    sha256 = "1rn5lz81y4bvgjhxzd57qhr0lmkm5xljl4bj9w10lnm4f7ls0xdi";
  };

  nativeBuildInputs = [
    git
    poetry-core
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    attrs
    future
    aiohttp
    aiohttp-socks
    aiofiles
    h11
    h2
    Logbook
    jsonschema
    unpaddedbase64
    pycryptodome
    python-olm
    peewee
    cachetools
    atomicwrites
  ];

  checkInputs = [
    faker
    aioresponses
    hypothesis
    pytest-aiohttp
    pytest-benchmark
  ];

  disabledTests = [
    # touches network
    "test_connect_wrapper"
    # time dependent and flaky
    "test_transfer_monitor_callbacks"
  ];

  meta = with lib; {
    description = "A Python Matrix client library, designed according to sans I/O principles";
    homepage = "https://github.com/poljar/matrix-nio";
    license = licenses.isc;
    maintainers = with maintainers; [ tilpner emily symphorien ];
  };
}
