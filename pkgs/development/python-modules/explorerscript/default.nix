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
  version = "0.2.1.post2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "explorerscript";
    rev = "refs/tags/${version}";
    hash = "sha256-cKEceWr7XmZbuomPOmjQ32ptAjz3LZDQBWAgZEFadDY=";
    # Include a pinned antlr4 fork used as a C++ library
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
    scikit-build-core
    ninja
    cmake
    pybind11
  ];

  # The source include some auto-generated ANTLR code that could be recompiled, but trying that resulted in a crash while decompiling unionall.ssb.
  # We thus do not rebuild them.

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "scikit-build-core<=0.9.8" scikit-build-core
  '';

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
