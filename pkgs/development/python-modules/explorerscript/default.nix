{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  igraph,
  pygments,
  scikit-build-core,
  pybind11,
  ninja,
  cmake,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "explorerscript";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "explorerscript";
    tag = version;
    hash = "sha256-fh40HCU12AVA3cZ5xvRott+93qo8VzHFsbPzTkoV3x4=";
    # Include a pinned antlr4 fork used as a C++ library
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pybind11>=2.13.6, < 2.14" "pybind11" \
      --replace-fail "scikit-build-core>=0.10.7, < 0.11" "scikit-build-core"
  '';

  build-system = [
    setuptools
    scikit-build-core
    pybind11
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  # The source include some auto-generated ANTLR code that could be recompiled, but trying that resulted in a crash while decompiling unionall.ssb.
  # We thus do not rebuild them.

  dontUseCmakeConfigure = true;

  pythonRelaxDeps = [
    "igraph"
  ];

  dependencies = [
    igraph
  ];

  optional-dependencies.pygments = [ pygments ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.pygments;

  pythonImportsCheck = [ "explorerscript" ];

  meta = {
    homepage = "https://github.com/SkyTemple/explorerscript";
    description = "Programming language + compiler/decompiler for creating scripts for Pokémon Mystery Dungeon Explorers of Sky";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
