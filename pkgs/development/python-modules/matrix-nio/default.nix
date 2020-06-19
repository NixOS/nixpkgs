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
  pname = "matrix-nio";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    sha256 = "1d4jhl2xjjp31yjs4zz2cfkvzbi2vr5bsrp07s6nhyc18azxr7ba";
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
    maintainers = with maintainers; [ tilpner emily symphorien ];
  };
}
