{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  toml,
  zipp,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "8.7.1";
  pyproject = true;

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    hash = "sha256-Sf7xrmRAwYIFL0B8jTSmj3Lvw225ypDcARM5jy/d6Ls=";
  };

  postPatch = ''
    sed -i "/coherent.licensed/d" pyproject.toml
  '';

  build-system = [
    setuptools # otherwise cross build fails
    setuptools-scm
  ];

  dependencies = [
    toml
    zipp
  ];

  # Cyclic dependencies due to pyflakefs
  doCheck = false;

  pythonImportsCheck = [ "importlib_metadata" ];

  passthru.tests = {
    inherit sage;
  };

  meta = {
    description = "Read metadata from Python packages";
    homepage = "https://importlib-metadata.readthedocs.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
    ];
  };
}
