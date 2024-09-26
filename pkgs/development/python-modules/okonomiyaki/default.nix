{
  buildPythonPackage,
  stdenv,
  fetchFromGitHub,
  lib,
  attrs,
  distro,
  jsonschema,
  six,
  zipfile2,
  hypothesis,
  mock,
  packaging,
  testfixtures,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "okonomiyaki";
  version = "1.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "enthought";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-MEll1H7l41m8uz2/WK/Ilm7Dubg0uqYwe+ZgakO1aXQ=";
  };

  propagatedBuildInputs = [
    distro
    attrs
    jsonschema
    six
    zipfile2
  ];

  preCheck =
    ''
      substituteInPlace okonomiyaki/runtimes/tests/test_runtime.py \
        --replace 'runtime_info = PythonRuntime.from_running_python()' 'raise unittest.SkipTest() #'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace okonomiyaki/platforms/tests/test_pep425.py \
        --replace 'self.assertEqual(platform_tag, self.tag.platform)' 'raise unittest.SkipTest()'
    '';

  checkInputs = [
    hypothesis
    mock
    packaging
    testfixtures
  ];

  pythonImportsCheck = [ "okonomiyaki" ];

  meta = with lib; {
    homepage = "https://github.com/enthought/okonomiyaki";
    description = "Experimental library aimed at consolidating a lot of low-level code used for Enthought's eggs";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
    broken = pythonAtLeast "3.12"; # multiple tests are failing
  };
}
