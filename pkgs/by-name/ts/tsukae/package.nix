{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule {
  pname = "tsukae";
  version = "0-unstable-2021-04-19";

  src = fetchFromGitHub {
    owner = "irevenko";
    repo = "tsukae";
    rev = "8111dddd67e4b4f83ae4bca7d7305f6dc64e77cd";
    sha256 = "sha256-1y/WYLW6/HMGmuaX2wOlQbwYn0LcgQCMb4qw8BtCgxQ=";
  };

  vendorHash = "sha256-Q0WOzyJGnTXTmj7ZPKyVSnWuWb4bbDjDpgftQ1Opf/I=";

  meta = {
    description = "Show off your most used shell commands";
    homepage = "https://github.com/irevenko/tsukae";
    license = lib.licenses.mit;
    mainProgram = "tsukae";
    maintainers = with lib.maintainers; [ l3af ];
  };
}
