{ lib, buildPythonPackage, fetchFromGitHub, git,
  attrs, future, peewee, h11, h2, atomicwrites, pycryptodome, sphinx, Logbook, jsonschema,
  python-olm, unpaddedbase64, aiohttp, cachetools }:

buildPythonPackage rec {
  pname = "nio";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "matrix-nio";
    rev = version;
    sha256 = "0pq5i6ks3pck2kq9m4p3pw9hbvkzs27xkyv68mjnfc6chp2g2mg9";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'python-olm>=3.1.0' ""
  '';

  nativeBuildInputs = [
    git
  ];

  propagatedBuildInputs = [
    attrs
    future
    peewee
    h11
    h2
    atomicwrites
    pycryptodome
    sphinx
    Logbook
    jsonschema
    python-olm
    unpaddedbase64
    aiohttp
    cachetools
  ];

  doCheck = false;

  meta = with lib; {
    description = "A Python Matrix client library, designed according to sans I/O principles";
    homepage = "https://github.com/poljar/matrix-nio";
    license = licenses.isc;
    maintainers = [ maintainers.tilpner ];
  };
}
