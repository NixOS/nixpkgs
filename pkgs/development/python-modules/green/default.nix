{ lib, buildPythonPackage, fetchPypi, isPy3k
, colorama
, coverage
, termstyle
, lxml
, unidecode
}:

buildPythonPackage rec {
  pname = "green";
  version = "3.3.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4d86f2dfa4ccbc86f24bcb9c9ab8bf34219c876c24e9f0603aab4dfe73bb575";
  };

  propagatedBuildInputs = [
    colorama coverage termstyle unidecode lxml
  ];

  # let green run it's own test suite
  checkPhase = ''
    $out/bin/green green
  '';

  meta = with lib; {
    description = "Python test runner";
    homepage = "https://github.com/CleanCut/green";
    license = licenses.mit;
  };
}
