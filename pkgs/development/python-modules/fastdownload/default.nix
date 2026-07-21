{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  fastprogress,
  fastcore,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastdownload";
  version = "0.0.7";
  pyproject = true;
  __structuredAttrs = true;

  # No tag for 0.0.7 on GitHub
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-IFB+246JQGofvXd15uKj2BpN1jPdUGsOnPDhYT6DHWo=";
  };

  # pkg_resources used to come with setuptools but was removed
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "from pkg_resources import parse_version" \
        "from packaging.version import parse as parse_version"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    fastprogress
    fastcore
  ];

  pythonImportsCheck = [ "fastdownload" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Easily download, verify, and extract archives";
    homepage = "https://github.com/fastai/fastdownload";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
  };
})
