{ lib
, stdenvNoCC
, makeWrapper
, xorg
, clang-tools
, clang-unwrapped
, python3
, llvm_meta
# For tests
, runCommandLocal
, git
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "clang-tools-python";
  inherit (clang-unwrapped) version;

  passthru.tests = {
    git-clang-format-help = runCommandLocal "test-git-clang-format-help" {
      nativeBuildInputs = [
        finalAttrs.finalPackage
        git
      ];
    } ''
      set -eu -o pipefail
      git-clang-format --help | tee "$out"
    '';
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    xorg.lndir
  ];

  # During install, we provides the clang-tools utilities from `clang-tools` through PATH-prefixing
  # to make the Python scripts run out-of-the-box.
  # This changes the default behavior for them to pick up the command from the environment.
  # For example, git-clang-format from the upstream looks for the `clang-format` command from the environment by default,
  # and now we provide a wrapper to feed the `clang-format` command from `clang-tools` through PATH-prefixing.
  # The binary can still be specified as `git-clang-format --binary path/to/clang-format`.

  installPhase = ''
    runHook preInstall

    # Link and wrap python scripts (copy-free replacement to patchShebangs)
    mkdir -p "$out/bin"
    substitute "${./wrapper-python}" "$out/bin/.python3-script-wrapper" \
      --replace "@pythonInterpreter@" "${python3.interpreter}" \
      --replace "@clangUnwrappedPython@" "${clang-unwrapped.python}" \
      --replace "###PATH_PREFIXING_COMMAND###" "PATH=${lib.makeBinPath [ clang-tools ]}\''${PATH:+:}\''${PATH-}; export PATH"
    chmod +x "$out/bin/.python3-script-wrapper"

    for tool in ${clang-unwrapped.python}/bin/*; do
      ln -s "$out/bin/.python3-script-wrapper" "$out/bin/$(basename "$tool")"
    done

    # Python script executables may depend on modules stored in "''${clang-unwrapped.python}/share"
    mkdir -p $out/share
    lndir -silent "${clang-unwrapped.python}/share" "$out/share"

    runHook postInstall
  '';

  meta = llvm_meta // {
    description = "Standalone Python scripts provided by Clang";
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
})
