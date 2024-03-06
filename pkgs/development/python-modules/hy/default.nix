{ lib
, astor
, buildPythonPackage
, fetchFromGitHub
, funcparserlib
, hy
, pytestCheckHook
, python
, pythonOlder
, testers
}:

buildPythonPackage rec {
  pname = "hy";
  version = "0.28.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hylang";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-XH8qZ6OsTrFXcv/8ZyrTtN6l50JXIUcHJbfCRXHzSTs=";
  };

  # https://github.com/hylang/hy/blob/1.0a4/get_version.py#L9-L10
  HY_VERSION = version;

  propagatedBuildInputs = [
    funcparserlib
  ] ++
  lib.optionals (pythonOlder "3.9") [
    astor
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
