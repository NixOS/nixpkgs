{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hypothesis,
  pytest-xdist,
  pytestCheckHook,
  typing-extensions,
  wheel,
}:

buildPythonPackage rec {
  pname = "bidict";
  version = "0.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jab";
    repo = "bidict";
    tag = "v${version}";
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

  meta = {
    homepage = "https://bidict.readthedocs.io";
    changelog = "https://bidict.readthedocs.io/changelog.html";
    description = "Bidirectional mapping library for Python";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      jab
      jakewaksbaum
    ];
  };
}
