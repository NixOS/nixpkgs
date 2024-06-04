{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  setuptools,
  cmake,
  nanobind,
  ninja,
  pcpp,
  scikit-build,
  isl,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "islpy";
  version = "2024.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "islpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-N5XI6V3BvNobCh7NAvtzVejtDMnlcb31S5gseyab1T0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
        --replace-fail "setuptools>=42,<64;python_version<'3.12'" "setuptools>=42"
  '';

  build-system = [
    setuptools
    cmake
    nanobind
    ninja
    pcpp
    scikit-build
  ];

  buildInputs = [ isl ];

  dontUseCmakeConfigure = true;

  preConfigure = ''
    python ./configure.py \
        --no-use-shipped-isl \
        --isl-inc-dir=${lib.getDev isl}/include \
  '';

  # Force resolving the package from $out to make generated ext files usable by tests
  preCheck = ''
    mv islpy islpy.hidden
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "islpy" ];

  meta = {
    description = "Python wrapper around isl, an integer set library";
    homepage = "https://github.com/inducer/islpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
