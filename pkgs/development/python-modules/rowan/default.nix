{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  scipy,
  numpy,
}:

buildPythonPackage rec {
  pname = "rowan";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "rowan";
    rev = "v${version}";
    hash = "sha256-fcxVpzLhbLjPIifNBx0olq1dUTmNM9IH38MQybkWZSg=";
  };

  nativeBuildInputs = [
    setuptools
  ];
  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "rowan" ];

  meta = with lib; {
    description = "Python package for working with quaternions";
    homepage = "https://github.com/glotzerlab/rowan";
    changelog = "https://github.com/glotzerlab/rowan/blob/${src.rev}/ChangeLog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
