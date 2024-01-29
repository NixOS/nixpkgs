{ lib
, buildPythonPackage
, llvmPackages
, setuptools
, writeText
}:

let
  libclang = llvmPackages.libclang;

  pyproject_toml = writeText "pyproject.toml" ''
    [build-system]
    requires = ["setuptools>=42", "wheel"]
    build-backend = "setuptools.build_meta"
  '';

  setup_cfg = writeText "setup.cfg" ''
    [metadata]
    name = clang
    version = ${libclang.version}

    [options]
    packages = clang
  '';
in buildPythonPackage {
  pname = "libclang";
  format = "pyproject";

  inherit (libclang) version src;

  buildInputs = [ setuptools ];

  postUnpack = ''
    # set source root to python bindings
    if [ -e "$sourceRoot/clang/bindings/python" ]; then
      # LLVM 13+ puts clang sources in subdirectory instead of plain tarball
      sourceRoot="$sourceRoot/clang/bindings/python"
    else
      sourceRoot="$sourceRoot/bindings/python"
    fi
  '';

  postPatch = ''
    # link in our own build info to build as a python package
    ln -s ${pyproject_toml} ./pyproject.toml
    ln -s ${setup_cfg} ./setup.cfg

    # set passed libclang for runtime
    echo 'Config.set_library_path("${lib.getLib libclang}/lib")' >>./clang/cindex.py
  '';

  meta = libclang.meta // {
    description = "Python bindings for the C language family frontend for LLVM";
    maintainers = with lib.maintainers; [ lilyinstarlight ];
  };
}
