{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "asgineer";
  version = "0.8.2";
  format = "setuptools";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-UYnVlsdEhEAJF21zVmjAXX01K6LQR2I+Dfw5tSsmf5E=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  meta = with lib; {
    description = "A really thin ASGI web framework";
    license = licenses.bsd2;
    homepage = "https://asgineer.readthedocs.io";
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
