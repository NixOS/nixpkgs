{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  igraph,
  pygments,
  scikit-build-core,
  pybind11,
  ninja,
  ruff,
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
    repo = pname;
    rev = version;
    hash = "sha256-cKEceWr7XmZbuomPOmjQ32ptAjz3LZDQBWAgZEFadDY=";
    # Include a pinned antlr4 fork used as a C++ library
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    setuptools
    scikit-build-core
    ninja
    cmake
    ruff
  ];

  # The source include some auto-generated ANTLR code that could be recompiled, but trying that resulted in a crash while decompiling unionall.ssb.
  # We thus do not rebuild them.

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail ./generate_parser_bindings.py "python3 ./generate_parser_bindings.py"

    # Doesn’t detect that package for some reason
    substituteInPlace pyproject.toml \
      --replace-fail "\"scikit-build-core<=0.9.8\"," ""
  '';

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    igraph
    pybind11
  ];

  optional-dependencies.pygments = [ pygments ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.pygments;

  pythonImportsCheck = [ "explorerscript" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/explorerscript";
    description = "Programming language + compiler/decompiler for creating scripts for Pokémon Mystery Dungeon Explorers of Sky";
    license = licenses.mit;
    maintainers = with maintainers; [ marius851000 ];
  };
}
