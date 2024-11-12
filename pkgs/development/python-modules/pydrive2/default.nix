{
  lib,
  appdirs,
  buildPythonPackage,
  fetchPypi,
  fsspec,
  funcy,
  google-api-python-client,
  oauth2client,
  pyopenssl,
  pythonOlder,
  pyyaml,
  setuptools,
  setuptools-scm,
  tqdm,
}:

buildPythonPackage rec {
  pname = "pydrive2";
  version = "1.20.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Foum622DybCC8FvIy5Xuk85iOJ2ztVn/DnabW7iysQo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    google-api-python-client
    oauth2client
    pyopenssl
    pyyaml
  ];

  optional-dependencies = {
    fsspec = [
      appdirs
      fsspec
      funcy
      tqdm
    ];
  };

  # Tests require a account and network access
  doCheck = false;

  pythonImportsCheck = [ "pydrive2" ];

  meta = with lib; {
    description = "Google Drive API Python wrapper library";
    homepage = "https://github.com/iterative/PyDrive2";
    changelog = "https://github.com/iterative/PyDrive2/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sei40kr ];
  };
}
