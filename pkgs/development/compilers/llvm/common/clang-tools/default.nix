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
    # clang-unwrapped extracts headers outside the main derivation, into
    # clang-unwrapped.lib - this is at odds with clangd's header auto-detection
    # logic, which assumes it'll have them at <prefix>/lib.
    #
    # For simplicity, instead of working around this with the `CPATH` and
    # `CPLUS_INCLUDE_PATH` envs, let's just reconstruct the directory structure
    # expected by clangd - this avoids extra logic within the wrapper script.
    unwrapped = runCommand "clang-unwrapped-with-lib" { } ''
      mkdir $out
      mkdir $out/bin

      cp -a ${clang-unwrapped}/bin/clangd $out/bin/clangd
      ln -s ${clang-unwrapped.lib}/lib $out/lib
    '';

    pname = "clang-tools";
    version = lib.getVersion clang-unwrapped;
    dontUnpack = true;
    clang = if enableLibcxx then libcxxClang else clang;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin

      for tool in ${clang-unwrapped}/bin/clang-*; do
        tool=$(basename "$tool")

        # Compilers have their own derivation, no need to include them here:
        if [[ $tool == "clang-cl" || $tool == "clang-cpp" ]]; then
          continue
        fi

        # Clang's derivation produces a lot of binaries, but the tools we are
        # interested in follow the `clang-something` naming convention - except
        # for clang-$version (e.g. clang-13), which is the compiler again:
        if [[ ! $tool =~ ^clang\-[a-zA-Z_\-]+$ ]]; then
          continue
        fi

        ln -s $out/bin/clangd $out/bin/$tool
      done

      if [[ -z "$(ls -A $out/bin)" ]]; then
        echo "Found no binaries - maybe their location or naming convention changed?"
        exit 1
      fi

      substituteAll ${./wrapper} $out/bin/clangd
      chmod +x $out/bin/clangd

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
