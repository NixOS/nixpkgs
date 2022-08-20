{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, clvm
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clvm_tools";
  version = "0.4.4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_tools";
    rev = version;
    sha256 = "sha256-Fv7NTUEjbEDALyc+WLDQ7yJOdODZCwLobN+vUvaBWMY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    clvm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "clvm_tools"
  ];

  disabledTests = [
    "test_cmd_unknown-1_txt"
  ];

  # give a hint to setuptools-scm on package version
  SETUPTOOLS_SCM_PRETEND_VERSION="v${version}";

  meta = with lib; {
    description = "Tools for clvm development";
    homepage = "https://www.chialisp.com/";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
