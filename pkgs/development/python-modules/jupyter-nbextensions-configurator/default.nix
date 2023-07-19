{ lib
, buildPythonPackage
, fetchFromGitHub
, jupyter-contrib-core
}:

buildPythonPackage rec {
  pname = "jupyter-nbextensions-configurator";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "jupyter-contrib";
    repo = "jupyter_nbextensions_configurator";
    rev = "refs/tags/${version}";
    hash = "sha256-ovKYHATRAC5a5qTMv32ohU2gJd15/fRKXa5HI0zGp/0=";
  };

  propagatedBuildInputs = [ jupyter-contrib-core ];

  pythonImportsCheck = [ "jupyter_nbextensions_configurator" ];

  meta = with lib; {
    description = "A jupyter notebook serverextension providing config interfaces for nbextensions";
    homepage = "https://github.com/jupyter-contrib/jupyter_nbextensions_configurator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
