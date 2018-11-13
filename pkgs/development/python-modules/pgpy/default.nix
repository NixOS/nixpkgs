{ lib
, fetchPypi
, buildPythonPackage
, cryptography
, pyasn1
, six
, singledispatch
}:

buildPythonPackage rec {
  pname = "PGPy";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04412dddd6882ac0c5d5daf4326c28d481421851a68e25e7ac8e06cc9dc2b902";
  };

  buildInputs = [ cryptography pyasn1 six singledispatch ];
}
