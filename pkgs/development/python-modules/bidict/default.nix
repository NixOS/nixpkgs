{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, hypothesis
, pytest-xdist
, pytestCheckHook
, typing-extensions
, pythonOlder
, wheel
}:

buildPythonPackage rec {
  pname = "bidict";
  version = "0.23.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jab";
    repo = "bidict";
    rev = "refs/tags/v${version}";
    hash = "sha256-WE0YaRT4a/byvU2pzcByuf1DfMlOpYA9i0PPrKXsS+M=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-xdist
    pytestCheckHook
    typing-extensions
  ];

  # Remove the bundled pytest.ini, which adds options to run additional integration
  # tests that are overkill for our purposes.
  preCheck = ''
    rm pytest.ini
  '';

  pythonImportsCheck = [ "bidict" ];

  meta = with lib; {
    homepage = "https://bidict.readthedocs.io";
    changelog = "https://bidict.readthedocs.io/changelog.html";
    description = "The bidirectional mapping library for Python.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jab jakewaksbaum ];
  };
}
