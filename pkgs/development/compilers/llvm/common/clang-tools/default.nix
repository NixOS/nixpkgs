{
  lib,
  stdenv,
  runCommand,
  writeText,
  linkFarm,
  clang-unwrapped,
  clang,
  libcxxClang,
  llvm_meta,
  # enableLibcxx will use the c++ headers from clang instead of gcc.
  # This shouldn't have any effect on platforms that use clang as the default compiler already.
  enableLibcxx ? false,
}:

let
  clang-tools = stdenv.mkDerivation {
    unwrapped = clang-unwrapped;

    pname = "clang-tools";
    version = lib.getVersion clang-unwrapped;
    dontUnpack = true;
    clang = if enableLibcxx then libcxxClang else clang;

    installPhase = ''
      runHook preInstall

      function wrapTool {
        local tool="$1"
        local toolName="$2"

        cp $tool $out/bin/$toolName.unwrapped
        substituteAll ${./wrapper} $out/bin/$toolName
        chmod +x $out/bin/$toolName
      }

      mkdir -p $out/bin
      wrapTool ${clang-unwrapped}/bin/clangd clangd

      for tool in ${clang-unwrapped}/bin/clang-*; do
        toolName=$(basename "$tool")

        # Compilers have their own derivation, no need to include them here:
        if [[ $toolName == "clang-cl" || $toolName == "clang-cpp" ]]; then
          continue
        fi

        # Clang's derivation produces a lot of binaries, but the tools we are
        # interested in follow the `clang-something` naming convention - except
        # for clang-$version (e.g. clang-13), which is the compiler again:
        if [[ ! $toolName =~ ^clang\-[a-zA-Z_\-]+$ ]]; then
          continue
        fi

        wrapTool $tool $toolName
      done

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
        ${clang-tools}/bin/clangd --check=${src}
        touch $out
      '';

    passthru.tests.smokeErr =
      let
        src = writeText "main.cpp" ''
          int main() {
             std::cout << "Hi!";
          }
        '';

      in
      runCommand "clang-tools-test-smoke-err" { } ''
        (${clang-tools}/bin/clangd --check=${src} 2>&1 || true) \
            | grep 'use of undeclared identifier'

        touch $out
      '';

    meta = llvm_meta // {
      description = "Standalone command line tools for C++ development";
      maintainers = with lib.maintainers; [ patryk27 ];
    };
  };

in
clang-tools
