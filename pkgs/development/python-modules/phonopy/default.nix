{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pyyaml,
  matplotlib,
  h5py,
  scipy,
  spglib,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  scikit-build-core,
  cmake,
  setuptools-scm,
  ninja,
  pkg-config,
  nanobind,
}:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.29.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MabBtEOyM82R0NbdVaY+2f9GT8rT44xjOi/o38GSRp8=";
  };

  nativeBuildInputs = [
    setuptools
    scikit-build-core
    nanobind
    setuptools-scm
    ninja
    cmake
  ];
  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    h5py
    matplotlib
    numpy
    pyyaml
    scipy
    spglib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # prevent pytest from importing local directory
  preCheck = ''
    rm -r phonopy
  '';

  pythonImportsCheck = [ "phonopy" ];

  meta = with lib; {
    description = "Modulefor phonon calculations at harmonic and quasi-harmonic levels";
    homepage = "https://phonopy.github.io/phonopy/";
    changelog = "https://github.com/phonopy/phonopy/blob/v${version}/doc/changelog.md";
    license = licenses.bsd0;
    maintainers = with maintainers; [ psyanticy ];
  };
}
