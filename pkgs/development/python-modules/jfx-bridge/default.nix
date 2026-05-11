{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jfx-bridge";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justfoxing";
    repo = "jfx_bridge";
    tag = version;
    hash = "sha256-fpUrKNGqTpthhTfohCbwO1GBDAP/YnLWeapVhZftldg=";
  };

  patches = [ ./no-invoke-git.patch ];

  postPatch = ''
    substituteInPlace ./setup.py --subst-var-by version ${version}
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    ${python.interpreter} test_bridge_server.py &
  '';

  disabledTests = [
    # known to cause timeout with newer python (acknowledged in test comment)
    "test_nonreturn_marker_local"
    # the mechanisms that hook into the python import machinery seem broken on newer python
    "TestBridgeHookImport"
  ];

  pythonImportsCheck = [ "jfx_bridge" ];

  meta = {
    description = "Base Python RPC bridge used for ghidra_bridge";
    homepage = "https://github.com/justfoxing/jfx_bridge";
    changelog = "https://github.com/justfoxing/jfx_bridge/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scoder12 ];
  };
}
