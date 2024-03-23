{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, django
, colorama
, coverage
, unidecode
, lxml
}:

buildPythonPackage rec {
  pname = "green";
  version = "4.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O178HRtyKg/2fYD9jHzfbUfNGPlRpGuEvbx7H7yr0/w=";
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
