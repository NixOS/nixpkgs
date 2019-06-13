{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
, stdenv
}:


buildPythonPackage rec {
  pname = "more-itertools";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "590044e3942351a1bdb1de960b739ff4ce277960f2425ad4509446dbace8d9d1";
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
