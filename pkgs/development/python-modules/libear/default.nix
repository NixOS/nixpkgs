{
  lib,
  llvmPackages,
  buildPythonPackage,
}:
let
  inherit (llvmPackages) clang-unwrapped;
in
buildPythonPackage rec {
  pname = "libear";
  inherit (clang-unwrapped) version;

  format = "other";

  src = clang-unwrapped.lib + "/lib/libear";

  dontUnpack = true;

  installPhase = ''
    LIBPATH="$(toPythonPath "$out")/libear"
    mkdir -p "$LIBPATH"

    install -t "$LIBPATH" $src/*
  '';

  pythonImportsCheck = [ "libear" ];

  meta = {
    description = "Hooks into build systems to listen to which files are opened";
    homepage = "https://github.com/llvm/llvm-project/tree/llvmorg-${version}/clang/tools/scan-build-py/lib/libear";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ RossSmyth ];
  };
}
