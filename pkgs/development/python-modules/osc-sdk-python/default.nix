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
  version = "0.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "osc-sdk-python";
    tag = "v${version}";
    hash = "sha256-5Ws/yPIw0H+FV9oRZLsywap1eqIkCOEK1yGhk0Ft6Ic=";
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
  pytestFlagsArray = [ "tests/test_net.py" ];

  pythonImportsCheck = [ "osc_sdk_python" ];

  meta = with lib; {
    description = "SDK to perform actions on Outscale API";
    homepage = "https://github.com/outscale/osc-sdk-python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nicolas-goudry ];
  };
}
