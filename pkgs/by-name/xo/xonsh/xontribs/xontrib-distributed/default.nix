{
  buildPythonPackage,
  lib,
  fetchFromGitHub,

  distributed,
  poetry-core,
  pytestCheckHook,
  xonsh
}:

buildPythonPackage rec {
  pname = "xontrib-distributed";
  version = "0.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-distributed";
    rev = "v${version}";
    hash = "sha256-Hb7S3PqHi0w6zb9ki8ADMtgdYVv8O5WQZMgJzKF74qE=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace 'xonsh = ">=0.12"' ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    distributed
  ];

  # v0.0.4 has no tests associated with it
  doCheck = false;

  checkInputs = [
    pytestCheckHook
    xonsh
  ];

  meta = with lib; {
    description = "Dask Distributed integration for Xonsh";
    homepage = "https://github.com/xonsh/xontrib-distributed";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };
}
