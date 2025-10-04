{
  lib,
  ghidra,
  makeWrapper,
  buildPythonPackage,
  jpype1,
  setuptools,
}:

buildPythonPackage {
  pname = "pyghidra";
  inherit (ghidra) version;

  src = ghidra.pyghidrasrc;

  pyproject = true;

  build-system = [ setuptools ];
  dependencies = [ jpype1 ];

  nativeBuildInputs = [ makeWrapper ];

  makeWrapperArgs = [
    "--set GHIDRA_INSTALL_DIR ${ghidra}/lib/ghidra"
    "--prefix PATH : ${lib.makeBinPath [ ghidra.jdk ]}"
  ];

  meta = ghidra.meta // {
    description = "Python library that provides direct access to the Ghidra API within a native CPython 3 interpreter using JPype";
    mainProgram = "pyghidra";
    maintainers = with lib.maintainers; [ vlaci ];
  };
}
