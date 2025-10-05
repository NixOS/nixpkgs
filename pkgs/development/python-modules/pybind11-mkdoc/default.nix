{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  flit-core,
  docutils,
  libclang,
  clang,
}:

buildPythonPackage rec {
  pname = "pybind11_mkdoc";
  version = "0-unstable-2023-02-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11_mkdoc";
    rev = "42fbf377824185e255b06d68fa70f4efcd569e2d";
    hash = "sha256-rXcJkOrxOGr1Ou+BuQYZzJTw8BV3h71/uYkpnMbP3Q0=";
  };

  nativeBuildInputs = [ flit-core ];
  propagatedBuildInputs = [
    docutils
    libclang
  ];

  meta = {
    description = "Docstring extraction tool for pybind11 C++ bindings";
    homepage = "https://github.com/pybind/pybind11_mkdoc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phodina ];
    mainProgram = "pybind11_mkdoc";
  };
}
