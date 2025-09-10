{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  nanobind,
  ninja,
  numpy,
  scikit-build-core,
  setuptools,
  setuptools-scm,

  # dependencies
  h5py,
  matplotlib,
  pyyaml,
  scipy,
  spglib,
  symfc,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.38.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phonopy";
    repo = "phonopy";
    tag = "v${version}";
    hash = "sha256-oQcKBwrjQGmjJIHROb9Z/8j7CmfoSxlIzHRABBg+tSs=";
  };

  build-system = [
    cmake
    nanobind
    ninja
    numpy
    scikit-build-core
    setuptools
    setuptools-scm
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    h5py
    matplotlib
    numpy
    pyyaml
    scipy
    spglib
    symfc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # prevent pytest from importing local directory
  preCheck = ''
    rm -r phonopy
  '';

  pythonImportsCheck = [ "phonopy" ];

  meta = {
    description = "Modulefor phonon calculations at harmonic and quasi-harmonic levels";
    homepage = "https://phonopy.github.io/phonopy/";
    changelog = "http://phonopy.github.io/phonopy/changelog.html";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [
      psyanticy
      chn
    ];
  };
}
