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
  version = "2024.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "islpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-ixw9U4WqcXBW6KGBOsUImjsxmvG5XKCv4jCbTjJ4pjg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
        --replace-fail "setuptools>=42,<64;python_version<'3.12'" "setuptools>=42"
  '';

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
