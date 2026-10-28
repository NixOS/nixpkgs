{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  hatch-requirements-txt,
  pytest,
  unstableGitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-ticket";
  version = "0-unstable-2025-05-15";
  pyproject = true;

  # hatch-vcs validates this against PEP 440 and 0-unstable-* is not a valid PEP 440 version string
  env.SETUPTOOLS_SCM_PRETEND_VERSION = builtins.elemAt (builtins.split "-" finalAttrs.version) 0;

  src = fetchFromGitHub {
    owner = "next-actions";
    repo = "pytest-ticket";
    rev = "9f77e77d99ee25a65cad2ab07815884bf7271552";
    hash = "sha256-oR0kwrr8nnrVpWc27pOtM+6K00llTQGRTpvKmOyCIYY=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-requirements-txt
  ];

  dependencies = [
    pytest
  ];

  # Patch requirements.txt out of the package
  postInstall = ''
    rm -f $out/lib/python*/site-packages/requirements.txt
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "pytest plugin that adds the ability to filter test cases by an associated ticket of a tracker of your choice";
    homepage = "https://github.com/next-actions/pytest-ticket";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ joaosreis ];
  };
})
