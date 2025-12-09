{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  hydra-core,
  joblib,

  # test
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hydra-joblib-launcher";
  pyproject = true;

  inherit (hydra-core) version src;

  sourceRoot = "${src.name}/plugins/hydra_joblib_launcher";

  # get rid of deprecated "read_version" dependency, no longer in Nixpkgs:
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail ', "read-version"' ""
    substituteInPlace setup.py  \
      --replace-fail 'from read_version import read_version' ""  \
      --replace-fail 'version=read_version("hydra_plugins/hydra_joblib_launcher", "__init__.py"),' 'version="${version}",'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    hydra-core
    joblib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # tries to write to source directory otherwise:
  pytestFlagsArray = [ "-p no:cacheprovider" ];

  meta = {
    inherit (hydra-core.meta) changelog license;
    description = "Hydra launcher supporting parallel execution based on Joblib.Parallel";
    homepage = "https://hydra.cc/docs/plugins/joblib_launcher";
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
