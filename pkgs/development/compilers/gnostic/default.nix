{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gnostic";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Wpe+rK4XMfMZYhR1xTEr0nsEjRGkSDA7aiLeBbGcRpA=";
  };

  vendorHash = "sha256-Wyv5czvD3IwE236vlAdq8I/DnhPXxdbwZtUhun+97x4=";

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
