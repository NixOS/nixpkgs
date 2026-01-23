{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  poetry-core,
  distributed,
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  xonsh,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "xontrib-distributed";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-distributed";
    tag = "v${version}";
    hash = "sha256-Hb7S3PqHi0w6zb9ki8ADMtgdYVv8O5WQZMgJzKF74qE=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'xonsh = ">=0.12"' ""
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    distributed
  ];

  # As of v0.0.4 has no tests that get run by pytest
  doCheck = false;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
    xonsh
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dask Distributed integration for Xonsh";
    homepage = "https://github.com/xonsh/xontrib-distributed";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ greg ];
  };
}
