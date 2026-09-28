{
  lib,
  stdenv,
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
  phonors,
  pyyaml,
  scipy,
  spglib,
  symfc,

  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "phonopy";
  version = "4.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "phonopy";
    repo = "phonopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w31B4/o/lo/0LIfrn7DR2cJ2OY6Pfe4zAMgcQfJ2q1g=";
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
    phonors
    scipy
    spglib
    symfc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Prevents 'Fatal Python error: Aborted' on darwin during checkPhase
    MPLBACKEND = "Agg";
  };

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
