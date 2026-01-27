{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  ruamel-yaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "osc-sdk-python";
  version = "0.38.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "osc-sdk-python";
    tag = "v${version}";
    hash = "sha256-dS4vwBSvsjPu8JToXPww2tfN+zzCK/qzbxyZwA/n6js=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
    ruamel-yaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "ruamel.yaml==0.17.32" "ruamel.yaml"
  '';

  # Only keep test not requiring access and secret keys
  enabledTestPaths = [ "tests/test_net.py" ];

  pythonImportsCheck = [ "osc_sdk_python" ];

  meta = {
    description = "SDK to perform actions on Outscale API";
    homepage = "https://github.com/outscale/osc-sdk-python";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
