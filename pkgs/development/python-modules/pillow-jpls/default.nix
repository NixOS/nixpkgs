{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  cmake,
  ninja,
  scikit-build-core,
  charls,
  eigen,
  fmt,
  numpy,
  pillow,
  pybind11,
  setuptools,
  pathspec,
  pyproject-metadata,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pillow-jpls";
  version = "1.3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "planetmarshall";
    repo = "pillow-jpls";
    rev = "refs/tags/v${version}";
    hash = "sha256-Rc4/S8BrYoLdn7eHDBaoUt1Qy+h0TMAN5ixCAuRmfPU=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dontUseCmakeConfigure = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"conan~=2.0.16",' "" \
      --replace-fail '"pybind11~=2.11.1",' '"pybind11",'
  '';

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    charls
    eigen
    fmt
  ];

  dependencies = [
    numpy
    pillow
    pathspec
    pyproject-metadata
  ];

  pypaBuildFlags = [
    "-C"
    "cmake.args=--preset=sysdeps"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Prevent importing from build during test collection:
  preCheck = ''rm -rf pillow_jpls'';

  pythonImportsCheck = [ "pillow_jpls" ];

  meta = with lib; {
    description = "JPEG-LS plugin for the Python Pillow library";
    homepage = "https://github.com/planetmarshall/pillow-jpls";
    changelog = "https://github.com/planetmarshall/pillow-jpls/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
