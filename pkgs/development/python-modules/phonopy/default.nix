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

buildPythonPackage (finalAttrs: {
  pname = "phonopy";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phonopy";
    repo = "phonopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JSLwABXVYhGm9nb4W9M0AKCU98grBpfyHp5JB8KcIJc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "nanobind<2.10.0" "nanobind"
  '';

  build-system = [
    cmake
    nanobind
    ninja
    numpy
    scikit-build-core
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
})
