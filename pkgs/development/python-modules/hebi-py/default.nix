{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "hebi-py";
  version = "2.7.9";
  pyproject = true;

  src = fetchPypi {
    pname = "hebi-py";
    inherit version;
    hash = "sha256-7B0oxG1CVDTUVDFTJpuYvaCj+HnCL/2zmsD33W4nTLs=";
  };

  build-system = [ setuptools ];
  dependencies = [
    numpy
    pyyaml
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "hebi" ];

  meta = {
    description = "Python library for the Hebi Robotics API";
    homepage = "https://docs.hebi.us/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
