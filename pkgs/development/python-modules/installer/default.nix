{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  flit-core,
  installer,
  mock,
}:

buildPythonPackage rec {
  pname = "installer";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "installer";
    rev = version;
    hash = "sha256-zOnDOaH+9h78Z1667n1Cr8HIm8+OPn2Vc1Zl4XksiCM=";
  };

  patches = [
    # Add -m flag to installer to correctly support cross
    # https://github.com/pypa/installer/pull/258
    ./cross.patch
  ];

  nativeBuildInputs = [ flit-core ];

  # We need to disable tests because this package is part of the bootstrap chain
  # and its test dependencies cannot be built yet when this is being built.
  doCheck = false;

  passthru.tests = {
    pytest = buildPythonPackage {
      pname = "${pname}-pytest";
      inherit version;
      pyproject = false;

      dontBuild = true;
      dontInstall = true;

      nativeCheckInputs = [
        installer
        mock
        pytestCheckHook
      ];
    };
  };

  meta = {
    description = "Low-level library for installing a Python package from a wheel distribution";
    homepage = "https://github.com/pypa/installer";
    changelog = "https://github.com/pypa/installer/blob/${src.rev}/docs/changelog.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.cpcloud ];
    teams = [ lib.teams.python ];
  };
}
