{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  pyyaml,
}:
buildPythonPackage rec {
  pname = "amdsmi";
  version = "6.3.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2IeUMJwQ8oAGuLjbhWPZPv+q8Sc9UCq8S79donI4BTA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    setuptools
    pyyaml
  ];

  meta = with lib; {
    homepage = "https://github.com/ml-energy/amdsmi";
    description = "Python bindings for ROCm/AMDSMI";
    license = licenses.mit;
  };
}
