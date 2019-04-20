{ lib
, buildPythonPackage
, fetchPypi
, jupyterlab_server
, notebook
, pythonOlder
, fetchpatch
}:

buildPythonPackage rec {
  pname = "jupyterlab";
  version = "0.35.4";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "deba0b2803640fcad72c61366bff11d5945173015961586d5e3b2f629ffeb455";
  };

  propagatedBuildInputs = [ jupyterlab_server notebook ];

  makeWrapperArgs = [
    "--set" "JUPYTERLAB_DIR" "$out/share/jupyter/lab"
  ];

  patches = [
    (fetchpatch {
      name = "bump-jupyterlab_server-version";
      url = https://github.com/jupyterlab/jupyterlab/commit/3b8d451e6f9a4c609e60cde5fbb3cc84aae79951.patch;
      sha256 = "08vv6rp1k5fbmvj4v9x1d9zb6ymm9pv8ml80j7p45r9fay34rndf";
    })
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
