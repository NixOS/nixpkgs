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
  version = "0.1.5";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nuAp4OMAfA3u3DJyORjFw7y7ZLsLCKEfxSFIXqNh+k0=";
  };

  propagatedBuildInputs = [ fastcore traitlets ipython ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "execnb" ];

  meta = with lib; {
    homepage = "https://github.com/fastai/execnb";
    description = "Execute a jupyter notebook, fast, without needing jupyter";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
  };
}
