{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  metakernel,
  pytestCheckHook,
  yasi,
}:

buildPythonPackage rec {
  pname = "calysto-scheme";
  version = "1.4.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Calysto";
    repo = "calysto_scheme";
    rev = "refs/tags/v${version}";
    hash = "sha256-gTBXdjm6Ry6DpjO9tP+acYxM+DQDh4dZQF+pyXrUCiI=";
  };

  propagatedBuildInputs = [
    yasi
    metakernel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "calysto_scheme" ];

  meta = with lib; {
    description = "A Scheme kernel for Jupyter that can use Python libraries";
    homepage = "https://github.com/Calysto/calysto_scheme";
    changelog = "https://github.com/Calysto/calysto_scheme/blob/${src.rev}/ChangeLog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kranzes ];
  };
}
