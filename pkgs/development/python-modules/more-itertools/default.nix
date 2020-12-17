{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
, stdenv
}:


buildPythonPackage rec {
  pname = "more-itertools";
  version = "8.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3a9005928e5bed54076e6e549c792b306fddfe72b2d1d22dd63d42d5d3899cf";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  # iterable = range(10 ** 10)  # Is efficiently reversible
  # OverflowError: Python int too large to convert to C long
  doCheck = !stdenv.hostPlatform.is32bit;

  meta = {
    homepage = "https://more-itertools.readthedocs.org";
    description = "Expansion of the itertools module";
    license = lib.licenses.mit;
  };
}
