{ lib
, buildPythonPackage
, fetchPypi
, jupyterlab_server
, notebook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jupyterlab";
  version = "1.2.6";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mc3nrj7fc5q2ajr09m261j386jsp8qjljg8anghlh8czc9ln4s2";
  };

  propagatedBuildInputs = [ jupyterlab_server notebook ];

  makeWrapperArgs = [
    "--set" "JUPYTERLAB_DIR" "$out/share/jupyter/lab"
  ];

  # Depends on npm
  doCheck = false;

  meta = with lib; {
    description = "Jupyter lab environment notebook server extension.";
    license = with licenses; [ bsd3 ];
    homepage = "https://jupyter.org/";
    maintainers = with maintainers; [ zimbatm costrouc ];
  };
}
