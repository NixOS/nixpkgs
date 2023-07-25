{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyter-core
, notebook
}:

buildPythonPackage rec {
  pname = "jupyter-contrib-core";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "jupyter-contrib";
    repo = "jupyter_contrib_core";
    rev = "refs/tags/${version}";
    hash = "sha256-UTtK+aKxBFkqKuHrt1ox8vdHyFz/9HiKFl7U4UQcG88=";
  };

  propagatedBuildInputs = [
    jupyter-core
    notebook
  ];

  pythonImportsCheck = [ "jupyter_contrib_core" ];

  meta = with lib; {
    description = "Common utilities for jupyter-contrib projects";
    homepage = "https://github.com/jupyter-contrib/jupyter_contrib_core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
