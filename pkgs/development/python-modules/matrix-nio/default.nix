{ lib
, buildPythonPackage
, fetchFromGitHub
, git
, attrs
, future
, aiohttp
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
}:

buildPythonPackage rec {
  pname = "nio";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    sha256 = "05cggfhsfa0irvzc7x3fndv6n0zszxxhmlv89r5rkrl5wvrhbb2h";
  };

  nativeBuildInputs = [
    git
  ];

  propagatedBuildInputs = [
    attrs
    future
    aiohttp
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

  doCheck = false;

  meta = with lib; {
    description = "A Python Matrix client library, designed according to sans I/O principles";
    homepage = "https://github.com/poljar/matrix-nio";
    license = licenses.isc;
    maintainers = with maintainers; [ tilpner emily ];
  };
}
