{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
, stdenv
}:


buildPythonPackage rec {
  pname = "more-itertools";
  version = "8.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HevKvrHfeTgUhZ1kqBrXyxBQTCQ0k2jM8hTGZMR09B8=";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  # iterable = range(10 ** 10)  # Is efficiently reversible
  # OverflowError: Python int too large to convert to C long
  doCheck = !stdenv.hostPlatform.is32bit;

  meta = {
    homepage = "https://more-itertools.readthedocs.org";
    changelog = "https://more-itertools.readthedocs.io/en/stable/versions.html";
    description = "Expansion of the itertools module";
    license = lib.licenses.mit;
  };
}
