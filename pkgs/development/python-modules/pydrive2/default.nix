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
  version = "1.19.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "PyDrive2";
    inherit version;
    hash = "sha256-Ia6n2idjXCw/cFDgICBhkfOwMFxlUDFebo491Sb4tTE=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    google-api-python-client
    oauth2client
    pyopenssl
    pyyaml
  ];

  passthru.optional-dependencies = {
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
