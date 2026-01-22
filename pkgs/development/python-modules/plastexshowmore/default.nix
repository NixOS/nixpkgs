{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  plasTeX,
}:

buildPythonPackage {
  pname = "plastexshowmore";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "plastexshowmore";
    owner = "PatrickMassot";
    tag = finalAttrs.version;
    hash = "sha256-fKjGt3bMAGUjUAea3IDo9wmcE/IJDB9vLEvFbqgWvDM=";
  };

  build-system = [ setuptools ];

  dependencies = [ plasTeX ];

  meta = {
    description = "PlasTeX plugin for adding navigation buttons";
    homepage = "https://github.com/PatrickMassot/plastexshowmore";
    maintainers = with lib.maintainers; [ niklashh ];
    license = lib.licenses.asl20;
  };
}
