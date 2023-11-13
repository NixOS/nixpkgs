{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gnostic";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+/KZmwVV3pnbv3JNwNk9Q2gcTyDxV1tgsDzW5IYnnds=";
  };

  vendorHash = "sha256-OoI1/OPBgAy4AysPPSCXGmf0S4opzxO7ZrwBsQYImwU=";

  # some tests are broken and others require network access
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/google/gnostic";
    description = "A compiler for APIs described by the OpenAPI Specification with plugins for code generation and other API support tasks";
    changelog = "https://github.com/google/gnostic/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
