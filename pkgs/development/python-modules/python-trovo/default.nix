{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "python-trovo";
  version = "0.1.7";
  pyproject = true;

  src = fetchPypi {
    pname = "python_trovo";
    inherit version;
    hash = "sha256-3EVSF4+nLvvM2RocNM2xz9Us5VrRRTCu/MWCcqwwikw=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ requests ];

  # No tests found
  doCheck = false;

  pythonImportsCheck = [ "trovoApi" ];

  meta = {
    description = "Python wrapper for the Trovo API";
    homepage = "https://codeberg.org/wolfangaukang/python-trovo";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
