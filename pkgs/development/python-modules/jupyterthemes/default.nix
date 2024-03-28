{ lib
, buildPythonPackage
, fetchPypi
, matplotlib
, jupyter-core
, lesscpy
, notebook
}:


buildPythonPackage rec {
  pname = "jupyterthemes";
  version = "0.20.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ko68DISyEquZufF1f8BYKj9Tkw06dbJJLZGnyLNqtB4=";
  };

  propagatedBuildInputs = [
    matplotlib
    jupyter-core
    lesscpy
    notebook
  ];

  pythonImportsCheck = [ "jupyterthemes" ];

  meta = {
    description = "Custom Jupyter Notebook Themes";
    homepage = "https://github.com/dunovank/jupyter-themes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ WhiteBlackGoose ];
  };
}
