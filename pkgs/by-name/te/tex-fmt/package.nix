{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tex-fmt";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "WGUNDERWOOD";
    repo = "tex-fmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-FfBJV7zIdGZvEOlM37DGbbs4dvIlwmTWTenWn434dIY=";
  };

  cargoHash = "sha256-4Vgzg7IpftUtqJK91qiW+pwe2SrMHtk4EgsAlk3f3Pk=";

  meta = {
    description = "LaTeX formatter written in Rust";
    homepage = "https://github.com/WGUNDERWOOD/tex-fmt";
    license = lib.licenses.mit;
    mainProgram = "tex-fmt";
    maintainers = with lib.maintainers; [ wgunderwood ];
  };
}
