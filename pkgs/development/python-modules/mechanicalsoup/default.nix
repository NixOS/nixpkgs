{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytest-cov-stub,
  pytest-httpbin,
  pytest-mock,
  pytestCheckHook,
  requests-mock,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mechanicalsoup";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MechanicalSoup";
    repo = "MechanicalSoup";
    tag = "v${version}";
    hash = "sha256-fu3DGTsLrw+MHZCFF4WHMpyjqkexH/c8j9ko9ZAeAwU=";
  };

  postPatch = ''
    # Is in setup_requires but not used in setup.py
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
    substituteInPlace setup.cfg \
      --replace " --flake8" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    lxml
    requests
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-httpbin
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "mechanicalsoup" ];

  disabledTests = [
    # Missing module
    "test_select_form_associated_elements"
  ];

  meta = with lib; {
    description = "Python library for automating interaction with websites";
    homepage = "https://github.com/hickford/MechanicalSoup";
    changelog = "https://github.com/MechanicalSoup/MechanicalSoup/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      jgillich
      fab
    ];
  };
}
