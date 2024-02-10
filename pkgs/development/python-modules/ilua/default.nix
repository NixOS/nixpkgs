{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, wheel
, jupyter-console
, jupyter-core
, pygments
, termcolor
, txzmq
}:

buildPythonPackage rec {
  pname = "ilua";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "guysv";
    repo = "ilua";
    rev = "0.2.1+pass.env.explicit.1";
    hash = "sha256-4RndqiSAVo1yF5zvVZMhIKOlTGRBlP67RsRe9wUfTAQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    jupyter-console
    jupyter-core
    pygments
    termcolor
    txzmq
  ];

  pythonImportsCheck = [ "ilua" ];

  meta = with lib; {
    description = "Portable Lua kernel for Jupyter";
    homepage = "https://github.com/guysv/ilua/";
    changelog = "https://github.com/guysv/ilua/blob/${src.rev}/CHANGES.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
