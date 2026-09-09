{
  lib,
  astor,
  buildPythonPackage,
  fetchFromGitHub,
  funcparserlib,
  pytestCheckHook,
  python,
  setuptools,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hy";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hylang";
    repo = "hy";
    tag = finalAttrs.version;
    hash = "sha256-qNgPuFG/j/q1osu/IJ8JbF+l/XiCphdhUYPOKbLEgTk=";
  };

  # https://github.com/hylang/hy/blob/1.0a4/get_version.py#L9-L10
  env.HY_VERSION = finalAttrs.version;

  build-system = [ setuptools ];

  dependencies = [ funcparserlib ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "-v";

  preCheck = ''
    # For test_bin_hy
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [ "hy" ];

  passthru = {
    # For backwards compatibility with removed pkgs/development/interpreters/hy
    # Example usage:
    #   hy.withPackages (ps: with ps; [ hyrule requests ])
    withPackages =
      python-packages:
      (python.withPackages (ps: (python-packages ps) ++ [ ps.hy ])).overrideAttrs (old: {
        name = "${finalAttrs.finalPackage.name}-env";
        meta = removeAttrs finalAttrs.finalPackage.meta [ "license" ];
      });
  };

  meta = {
    description = "LISP dialect embedded in Python";
    homepage = "https://hylang.org/";
    changelog = "https://github.com/hylang/hy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "hy";
    maintainers = with lib.maintainers; [
      mazurel
      nixy
    ];
  };
})
