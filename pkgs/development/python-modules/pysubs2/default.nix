{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysubs2";
  version = "1.7.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tkarabela";
    repo = pname;
    rev = version;
    hash = "sha256-PrpN+w/gCi7S9OmD6kbbvL9VlZEfy1DbehFTwjxsibA=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysubs2" ];

  meta = with lib; {
    homepage = "https://github.com/tkarabela/pysubs2";
    description = "Python library for editing subtitle files";
    mainProgram = "pysubs2";
    license = licenses.mit;
    maintainers = [ ];
  };
}
