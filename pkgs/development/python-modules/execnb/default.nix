{ lib
, buildPythonPackage
, fetchPypi
, fastcore
, traitlets
, ipython
, pythonOlder
}:

buildPythonPackage rec {
  pname = "execnb";
  version = "0.1.6";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KJ2XEHqFY0SxbAiVPWBFO0cyC0EWgGDso8wt7lBLTgU=";
  };

  propagatedBuildInputs = [ fastcore traitlets ipython ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "execnb" ];

  meta = with lib; {
    homepage = "https://github.com/fastai/execnb";
    description = "Execute a jupyter notebook, fast, without needing jupyter";
    mainProgram = "exec_nb";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
  };
}
