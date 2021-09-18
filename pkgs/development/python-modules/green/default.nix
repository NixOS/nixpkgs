{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, colorama
, coverage
, unidecode
, lxml
}:

buildPythonPackage rec {
  pname = "green";
  version = "3.3.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4d86f2dfa4ccbc86f24bcb9c9ab8bf34219c876c24e9f0603aab4dfe73bb575";
  };

  patches = [
    ./tests.patch
  ];

  postPatch = ''
    substituteInPlace green/test/test_integration.py \
      --subst-var-by green "$out/bin/green"
  '';

  propagatedBuildInputs = [
    colorama coverage unidecode lxml
  ];

  # let green run it's own test suite
  checkPhase = ''
    $out/bin/green -tvvv green
  '';

  meta = with lib; {
    description = "Python test runner";
    homepage = "https://github.com/CleanCut/green";
    license = licenses.mit;
  };
}
