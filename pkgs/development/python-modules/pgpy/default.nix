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

  propogatedBuildInputs = [ cryptography pyasn1 six singledispatch ];

  meta = with lib; {
    homepage = https://github.com/SecurityInnovation/PGPy;
    description = "Pretty Good Privacy for Python 2 and 3.";
    longDescription = ''
      PGPy is a Python (2 and 3) library for implementing Pretty Good Privacy
      into Python programs, conforming to the OpenPGP specification per RFC
      4880.
    '';
    license = licenses.bsd3;
  };
}
