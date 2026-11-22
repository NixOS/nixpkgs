{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pytun";
  version = "2.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "montag451";
    repo = "pytun";
    hash = "sha256-tzz3CJhdTCEzxgkjXBUl0Jt2K6PnDjDMfNdT7naGgOo=";
  };

  # Test directory contains examples, not tests.
  doCheck = false;

  meta = {
    homepage = "https://github.com/montag451/pytun";
    description = "Linux TUN/TAP wrapper for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ montag451 ];
    platforms = lib.platforms.linux;
  };
}
