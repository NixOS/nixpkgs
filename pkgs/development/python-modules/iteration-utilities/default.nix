{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "iteration-utilities";
  version = "0.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MSeifert04";
    repo = "iteration_utilities";
    rev = "refs/tags/v${version}";
    hash = "sha256-BiBbmZHo5B/u//LItqEcKtGXOA6xK+T1zoitR9XIiSU=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iteration_utilities" ];

  meta = with lib; {
    description = "Utilities based on Pythons iterators and generators";
    homepage = "https://github.com/MSeifert04/iteration_utilities";
    changelog = "https://github.com/MSeifert04/iteration_utilities/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
