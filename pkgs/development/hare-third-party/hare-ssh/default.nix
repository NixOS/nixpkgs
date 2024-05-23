{
  fetchFromSourcehut,
  hare,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-ssh";
  version = "0-unstable-2023-11-16";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ssh";
    rev = "c6a39e37ba4a42721594e0a907fe016f8e2198a8";
    hash = "sha256-I43TLPoImBsvkgV3hDy9dw0pXVt4ezINnxFtEV9P2/M=";
  };

  nativeBuildInputs = [ hare ];

  makeFlags = [
    "PREFIX=${builtins.placeholder "out"}"
    "HARECACHE=.harecache"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hare-ssh/";
    description = "SSH client & server protocol implementation for Hare";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ patwid ];

    inherit (hare.meta) platforms badPlatforms;
  };
})
