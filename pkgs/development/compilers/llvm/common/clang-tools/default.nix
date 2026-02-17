{
  lib,
  stdenv,
  runCommand,
  writeText,
  clang-unwrapped,
  clang,
  libcxxClang,
  llvm_meta,
  # enableLibcxx will use the c++ headers from clang instead of gcc.
  # This shouldn't have any effect on platforms that use clang as the default compiler already.
  enableLibcxx ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clang-tools";
  version = lib.getVersion clang-unwrapped;
  dontUnpack = true;
  clang = if enableLibcxx then libcxxClang else clang;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    for toolPath in ${clang-unwrapped}/bin/clangd ${clang-unwrapped}/bin/clang-*; do
      toolName=$(basename "$toolPath")

      # Compilers have their own derivations, no need to include them here
      if [[ $toolName == "clang-cl" || $toolName == "clang-cpp" || $toolName =~ ^clang\-[0-9]+$ ]]; then
        continue
      fi

      cp $toolPath $out/bin/$toolName-unwrapped
      substituteAll ${./wrapper} $out/bin/$toolName
      chmod +x $out/bin/$toolName
    done

    # clangd etc. find standard header files by looking at the directory the
    # tool is located in and appending `../lib` to the search path. Since we
    # are copying the binaries, they expect to find `$out/lib` present right
    # within this derivation, containing `stddef.h` and so on.
    #
    # Note that using `ln -s` instead of `cp` in the loop above wouldn't avoid
    # this problem, since it's `clang-unwrapped` which separates libs into a
    # different output in the first place - here we are merely "merging" the
    # directories back together, as expected by the tools.
    ln -s ${clang-unwrapped.lib}/lib $out/lib

    runHook postInstall
  '';

  passthru.tests.smokeOk =
    let
      src = writeText "main.cpp" ''
        #include <iostream>

        int main() {
          std::cout << "Hi!";
        }
      '';

    in
    runCommand "clang-tools-test-smoke-ok" { } ''
      ${finalAttrs.finalPackage}/bin/clangd  --check=${src}
      touch $out
    '';

  passthru.tests.smokeErr =
    let
      src = writeText "main.cpp" ''
        #include <iostream>

        int main() {
           std::cout << "Hi!";
        }
      '';

    in
    runCommand "clang-tools-test-smoke-err" { } ''
      (${finalAttrs.finalPackage}/bin/clangd --query-driver='**' --check=${src} 2>&1 || true) \
          | grep 'use of undeclared identifier'

      touch $out
    '';

  meta = llvm_meta // {
    description = "Standalone command line tools for C++ development";
    maintainers = with lib.maintainers; [ patryk27 ];
  };
})
