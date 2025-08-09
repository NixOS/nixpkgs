{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygtail";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bgreenlee";
    repo = "pygtail";
    rev = version;
    hash = "sha256-TlXTlxeGDd+elGpMjxcJCmRuJmp5k9xj6MrViRzcST4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pygtail" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Library for reading log file lines that have not been read";
    mainProgram = "pygtail";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/bgreenlee/pygtail";
  };
}
