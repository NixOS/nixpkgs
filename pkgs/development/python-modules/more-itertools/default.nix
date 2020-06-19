{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
, stdenv
}:


buildPythonPackage rec {
  pname = "more-itertools";
  version = "8.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "558bb897a2232f5e4f8e2399089e35aecb746e1f9191b6584a151647e89267be";
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
