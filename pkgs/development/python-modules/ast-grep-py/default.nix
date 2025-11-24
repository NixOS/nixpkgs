{
  lib,
  ast-grep,
  buildPythonPackage,
  rustPlatform,
  pytestCheckHook,
  nix-update-script,
}:
buildPythonPackage {
  inherit (ast-grep) version src cargoDeps;
  pname = "ast-grep-py";
  pyproject = true;

  buildAndTestSubdir = "crates/pyo3";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  prePatch = ''
    substituteInPlace ./crates/pyo3/tests/test_register_lang.py \
      --replace-fail '../..' ${ast-grep.src}
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ast_grep_py" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit (ast-grep.meta)
      description
      homepage
      changelog
      license
      ;
    maintainers = with lib.maintainers; [
      nezia
    ];
  };
}
