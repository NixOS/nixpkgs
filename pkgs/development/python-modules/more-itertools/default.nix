{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
, stdenv
}:


buildPythonPackage rec {
  pname = "more-itertools";
  version = "8.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f83822ae94818eae2612063a5101a7311e68ae8002005b5e05f03fd74a86a20";
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
