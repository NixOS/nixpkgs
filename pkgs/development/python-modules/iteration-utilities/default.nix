{ lib, buildPythonPackage, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "iteration-utilities";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "MSeifert04";
    repo = "iteration_utilities";
    rev = "v${version}";
    sha256 = "sha256-Q/ZuwAf+NPikN8/eltwaUilnLw4DKFm864tUe6GLDak=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "iteration_utilities" ];

  meta = with lib; {
    description = "Utilities based on Pythons iterators and generators";
    homepage = "https://github.com/MSeifert04/iteration_utilities";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
