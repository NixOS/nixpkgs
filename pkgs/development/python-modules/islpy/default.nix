{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  nanobind,
  ninja,
  pcpp,
  scikit-build,
  setuptools,

  # buildInputs
  isl,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "islpy";
  version = "2025.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "islpy";
    tag = "v${version}";
    hash = "sha256-njwNijl7kAbU7v6Bd6p0J9KnYzXZi9gVdqSf8qD0FXE=";
  };

  build-system = [
    cmake
    nanobind
    ninja
    pcpp
    scikit-build
    setuptools
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
    rm -rf islpy
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "islpy" ];

  meta = {
    description = "Python wrapper around isl, an integer set library";
    homepage = "https://github.com/inducer/islpy";
    changelog = "https://github.com/inducer/islpy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
