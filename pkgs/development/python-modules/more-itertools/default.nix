{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
, stdenv
}:


buildPythonPackage rec {
  pname = "more-itertools";
  version = "8.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b84b238cce0d9adad5ed87e745778d20a3f8487d0f0cb8b8a586816c7496458d";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  # iterable = range(10 ** 10)  # Is efficiently reversible
  # OverflowError: Python int too large to convert to C long
  doCheck = !stdenv.hostPlatform.is32bit;

  meta = {
    homepage = https://more-itertools.readthedocs.org;
    description = "Expansion of the itertools module";
    license = lib.licenses.mit;
  };
}
