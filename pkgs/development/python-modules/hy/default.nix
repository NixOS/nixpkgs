{
  lib,
  astor,
  buildPythonPackage,
  fetchFromGitHub,
  funcparserlib,
  hy,
  pytestCheckHook,
  python,
  pythonOlder,
  setuptools,
  testers,
}:

buildPythonPackage rec {
  pname = "hy";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hylang";
    repo = "hy";
    tag = version;
    hash = "sha256-zaTe9sRmW+lzpbNVrnj5ccp1xIbN10FD1Jst/hM78Lw=";
  };

  # https://github.com/hylang/hy/blob/1.0a4/get_version.py#L9-L10
  HY_VERSION = version;

  build-system = [ setuptools ];

  dependencies = [ funcparserlib ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # For test_bin_hy
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [ "hy" ];

  passthru = {
    tests.version = testers.testVersion {
      package = hy;
      command = "hy -v";
    };
    # For backwards compatibility with removed pkgs/development/interpreters/hy
    # Example usage:
    #   hy.withPackages (ps: with ps; [ hyrule requests ])
    withPackages =
      python-packages:
      (python.withPackages (ps: (python-packages ps) ++ [ ps.hy ])).overrideAttrs (old: {
        name = "${hy.name}-env";
        meta = lib.mergeAttrs (builtins.removeAttrs hy.meta [ "license" ]) { mainProgram = "hy"; };
      });
  };

  meta = with lib; {
    description = "LISP dialect embedded in Python";
    homepage = "https://hylang.org/";
    changelog = "https://github.com/hylang/hy/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      mazurel
      nixy
    ];
  };
}
