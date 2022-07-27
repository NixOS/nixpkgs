{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, django
, colorama
, coverage
, unidecode
, lxml
}:

buildPythonPackage rec {
  pname = "green";
  version = "3.4.2";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Jbmes0KDoYVbLzDJHSuNwB22ystzFBZkAXkce8CWwiE=";
  };

  patches = [
    ./tests.patch
  ];

  postPatch = ''
    substituteInPlace green/test/test_integration.py \
      --subst-var-by green "$out/bin/green"
  '';

  propagatedBuildInputs = [
    colorama
    coverage
    unidecode
    lxml
  ];

  # let green run it's own test suite
  checkPhase = ''
    $out/bin/green -tvvv \
      green.test.test_version \
      green.test.test_cmdline \
      green.test.test_command
  '';

  pythonImportsCheck = [
    "green"
  ];

  meta = with lib; {
    description = "Python test runner";
    homepage = "https://github.com/CleanCut/green";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
