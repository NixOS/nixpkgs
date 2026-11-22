{
  lib,
  buildPythonPackage,
  base91,
  rustPlatform,
  pytestCheckHook,

  # passthru
  python,
  runCommand,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybase91";
  # The same source and vendored crates as the base91 command-line tool:
  # updating base91 updates both.
  inherit (base91) version src cargoDeps;
  pyproject = true;

  cargoRoot = "rust";
  buildAndTestSubdir = "rust/base91";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "rust/base91/python-tests" ];

  pythonImportsCheck = [ "pybase91" ];

  # A minimal test program, as nixpkgs has no package using this library:
  # the bindings must encode exactly as the base91 command, and decode back.
  passthru.tests.matches-cli =
    runCommand "pybase91-matches-cli"
      {
        nativeBuildInputs = [
          base91
          (python.withPackages (_: [ finalAttrs.finalPackage ]))
        ];
      }
      ''
        python3 - <<'EOF'
        import subprocess
        import pybase91

        data = bytes(range(256)) * 41 + b"basE91"
        encoded = subprocess.run(
            ["b91enc"], input=data, capture_output=True, check=True
        ).stdout
        assert pybase91.encode(data) == encoded
        assert pybase91.decode(encoded) == data
        EOF
        touch $out
      '';

  meta = {
    description = "Python bindings to base91-rs, a basE91 encoder and decoder";
    homepage = "https://github.com/douzebis/base91";
    changelog = "https://github.com/douzebis/base91/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
  };
})
