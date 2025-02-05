{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "asgineer";
  version = "0.8.3";
  format = "setuptools";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-9F/66Yi394C1tZWK/BiaCltvRZGVNq+cREDHUoyVLr4=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  meta = with lib; {
    description = "Really thin ASGI web framework";
    license = licenses.bsd2;
    homepage = "https://asgineer.readthedocs.io";
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
