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
  version = "0.29.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hylang";
    repo = "hy";
    rev = "refs/tags/${version}";
    hash = "sha256-8b2V78mwzSThmVl1SfMGBw8VSpE5rCuucnIyD0nq5To=";
  };

  # https://github.com/hylang/hy/blob/1.0a4/get_version.py#L9-L10
  HY_VERSION = version;

  build-system = [ setuptools ];

  dependencies = [ funcparserlib ] ++ lib.optionals (pythonOlder "3.9") [ astor ];

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
    changelog = "https://github.com/hylang/hy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      mazurel
      nixy
      thiagokokada
    ];
  };
}
