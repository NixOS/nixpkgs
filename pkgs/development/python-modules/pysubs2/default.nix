{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysubs2";
  version = "1.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tkarabela";
    repo = "pysubs2";
    rev = version;
    hash = "sha256-fKSb7MfBHGft8Tp6excjfkVXKnHRER11X0QxbR1zD4I=";
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
