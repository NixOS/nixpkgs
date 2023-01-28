{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "py-nextbusnext";
  version = "0.1.5";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ViViDboarder";
    repo = "py_nextbus";
    rev = "v${version}";
    hash = "sha256-uUHA8v5iTISmPaTgk0RvcLLRM34f3JXUjZClKGXdMoI=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "py_nextbus" ];

  meta = {
    description = "Minimalistic Python client for the NextBus public API";
    homepage = "https://github.com/ViViDboarder/py_nextbus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
