{
  lib,
  llvmPackages,
  buildPythonPackage,
  libear,
}:
let
  inherit (llvmPackages) clang-unwrapped;
in
buildPythonPackage rec {
  pname = "libscanbuild";
  inherit (clang-unwrapped) version;

  format = "other";

  src = clang-unwrapped.lib + "/lib/libscanbuild";

  dontUnpack = true;

  dependencies = [
    libear
  ];

  installPhase = ''
    LIBPATH="$(toPythonPath "$out")/libscanbuild"
    mkdir -p "$LIBPATH"

    cp -r "$src/"* "$LIBPATH"
  '';

  pythonImportsCheck = [ "libscanbuild" ];

  meta = {
    description = "Captures all child process creation and log information about it";
    homepage = "https://github.com/llvm/llvm-project/tree/llvmorg-${version}/clang/tools/scan-build-py/lib/libscanbuild";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ RossSmyth ];
  };
}
