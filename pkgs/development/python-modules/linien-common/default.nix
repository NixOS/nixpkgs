{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  importlib-metadata,
  numpy,
  rpyc,
  scipy,
  appdirs,
  callPackage,
}:

buildPythonPackage rec {
  pname = "linien-common";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linien-org";
    repo = "linien";
    tag = "v${version}";
    hash = "sha256-j6oiP/usLfV5HZtKLcXQ5pHhhxRG05kP2FMwingiWm0=";
  };

  sourceRoot = "${src.name}/linien-common";

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "importlib-metadata"
    "numpy"
  ];

  dependencies = [
    importlib-metadata
    numpy
    rpyc
    scipy
    appdirs
  ];

  pythonImportsCheck = [ "linien_common" ];

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "Shared components of the Linien spectroscopy lock application";
    homepage = "https://github.com/linien-org/linien/tree/develop/linien-common";
    changelog = "https://github.com/linien-org/linien/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      fsagbuya
      doronbehar
    ];
    # Numpy 2 is not supported yet, because the server linien, (installed on the
    # RedPitaya) must use the same Numpy version as the client (installed with
    # Nix). The server linien is bound to use Numpy 1 because Numpy maintainers
    # don't distribute pre-built wheels for the armv7l architecture of
    # RedPitaya, and it is unfeasible to build it natively there - something
    # that `pip install numpy` naively tries to do. Hence, we are bound to use
    # on the server the preinstalled Numpy 1 sourced in the .deb package that
    # comes with the RedPitaya OS. See also:
    #
    # - https://github.com/linien-org/linien/commit/ebbb2276b500a18826d11893bb43699b65692c5e
    # - https://github.com/linien-org/linien/issues/377
    broken = lib.versionAtLeast numpy.version "2";
  };
}
