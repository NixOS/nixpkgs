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
, toPythonApplication
, hyDefinedPythonPackages ? python-packages: [ ] /* Packages like with python.withPackages */
}:

buildPythonPackage rec {
  pname = "hy";
  version = "1.0a4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hylang";
    repo = pname;
    rev = version;
    sha256 = "sha256-MBzp3jqBg/kH233wcgYYHc+Yg9GuOaBsXIfjFDihD1E=";
  };

  # https://github.com/hylang/hy/blob/1.0a4/get_version.py#L9-L10
  HY_VERSION = version;

  propagatedBuildInputs = [
    colorama
    funcparserlib
    rply # TODO: remove on the next release
  ]
  ++ lib.optionals (pythonOlder "3.9") [
    astor
  ]
  # for backwards compatibility with removed pkgs/development/interpreters/hy
  # See: https://github.com/NixOS/nixpkgs/issues/171428
  ++ (hyDefinedPythonPackages python.pkgs);

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Don't test the binary
    "test_bin_hy"
    "test_hystartup"
    "est_hy2py_import"
  ];

  pythonImportsCheck = [ "hy" ];

  passthru = {
    tests.version = testers.testVersion {
      package = hy;
      command = "hy -v";
    };
    # also for backwards compatibility with removed pkgs/development/interpreters/hy
    withPackages = python-packages: (toPythonApplication hy).override {
      hyDefinedPythonPackages = python-packages;
    };
  };

  meta = with lib; {
    description = "A LISP dialect embedded in Python";
    homepage = "https://hylang.org/";
    changelog = "https://github.com/hylang/hy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab mazurel nixy thiagokokada ];
  };
}
