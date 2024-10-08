{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zhG0VMOFPBsyg6q/aBCNFpsjO4X8XOs/C3Mr/iSqdG0=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd test
  '';

  disabledTests = [
    "test_delete_cookie"
    "test_error"
    "test_error_in_generator_callback"
    # timing sensitive
    "test_ims"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://bottlepy.org";
    description = "Fast and simple micro-framework for small web-applications";
    mainProgram = "bottle.py";
    downloadPage = "https://github.com/bottlepy/bottle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ koral ];
  };
}
