{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyter-contrib-core
, jupyter-highlight-selected-word
, jupyter-nbextensions-configurator
, lxml
}:

buildPythonPackage rec {
  pname = "jupyter-contrib-nbextensions";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ipython-contrib";
    repo = "jupyter_contrib_nbextensions";
    rev = "refs/tags/${version}";
    hash = "sha256-1o8tBfRw6jNcKfNE7xXrQaEhx+KOv7mLOruvuMDtJ1Q=";
  };

  propagatedBuildInputs = [
    jupyter-contrib-core
    jupyter-highlight-selected-word
    jupyter-nbextensions-configurator
    lxml
  ];

  pythonImportsCheck = [ "jupyter_contrib_nbextensions" ];

  meta = with lib; {
    description = "A collection of various notebook extensions for Jupyter";
    homepage = "https://github.com/ipython-contrib/jupyter_contrib_nbextensions";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
