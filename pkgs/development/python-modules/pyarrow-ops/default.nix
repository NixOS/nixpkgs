{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  cython,
  pyarrow,
  geoarrow-pandas,
  geoarrow-pyarrow,
}:

buildPythonPackage {
  pname = "pyarrow-ops";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TomScheffers";
    repo = "pyarrow_ops";
    rev = "d8ee38e47ed064a5e8179d53086ac5ed67c44e6a";
    hash = "sha256-g3dFAviGSafK2mLWgF4zhXHW8ffBnoQheeC+whAOLRY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    cython
    pyarrow
    geoarrow-pandas
    geoarrow-pyarrow
  ];

  doCheck = false; # no tests
  pythonImportsCheck = [ "pyarrow_ops" ];

  meta = {
    description = "Convenient pyarrow operations following the Pandas API";
    homepage = "https://github.com/TomScheffers/pyarrow_ops";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
