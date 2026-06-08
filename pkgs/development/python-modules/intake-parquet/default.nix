{
  lib,
  buildPythonPackage,
  dask,
  fastparquet,
  fetchFromGitHub,
  pandas,
  pyarrow,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "intake-parquet";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intake";
    repo = "intake-parquet";
    tag = version;
    hash = "sha256-zSwylXBKOM/tG5mwYtc0FmxwcKJ6j+lw1bxJqf57NY8=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  # Break circular dependency
  pythonRemoveDeps = [ "intake" ];

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    pandas
    dask
    fastparquet
    pyarrow
  ];

  doCheck = false;

  #pythonImportsCheck = [ "intake_parquet" ];

  meta = {
    description = "Parquet plugin for Intake";
    homepage = "https://github.com/intake/intake-parquet";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
