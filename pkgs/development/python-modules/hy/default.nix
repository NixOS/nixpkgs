{ lib
, astor
, buildPythonPackage
, colorama
, fetchFromGitHub
, funcparserlib
, hy
, pytestCheckHook
, python
, pythonOlder
, rply
, testers
}:

buildPythonPackage rec {
  pname = "hy";
  version = "0.25.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hylang";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-V+ZtPm17ESxCGpRieGvEeO2bkwHfZQ6k9lsnDWr6pqo=";
  };

  # https://github.com/hylang/hy/blob/1.0a4/get_version.py#L9-L10
  HY_VERSION = version;

  propagatedBuildInputs = [
    colorama
    funcparserlib
  ] ++
  lib.optionals (pythonOlder "3.9") [
    astor
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # For test_bin_hy
    export PATH="$out/bin:$PATH"
  '';

  disabledTests = [
    "test_circular_macro_require"
    "test_macro_require"
  ];

  pythonImportsCheck = [ "hy" ];

  passthru = {
    tests.version = testers.testVersion {
      package = hy;
      command = "hy -v";
    };
    # For backwards compatibility with removed pkgs/development/interpreters/hy
    # Example usage:
    #   hy.withPackages (ps: with ps; [ hyrule requests ])
    withPackages = python-packages:
      (python.withPackages
        (ps: (python-packages ps) ++ [ ps.hy ])).overrideAttrs (old: {
          name = "${hy.name}-env";
          meta = lib.mergeAttrs (builtins.removeAttrs hy.meta [ "license" ]) {
            mainProgram = "hy";
          };
        });
  };

  meta = with lib; {
    description = "A LISP dialect embedded in Python";
    homepage = "https://hylang.org/";
    changelog = "https://github.com/hylang/hy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab mazurel nixy thiagokokada ];
  };
}
