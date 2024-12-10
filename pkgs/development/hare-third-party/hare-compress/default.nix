{
  lib,
  stdenv,
  hare,
  harec,
  fetchFromSourcehut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-compress";
  version = "unstable-2023-11-01";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-compress";
    rev = "562706946871d1c994f60361883269916cbaa08e";
    hash = "sha256-sz8xPBZaUFye3HH4lkRnH52ye451e6seZXN/qvg87jE=";
  };

  nativeBuildInputs = [ hare ];

  makeFlags = [
    "HARECACHE=.harecache"
    "PREFIX=${builtins.placeholder "out"}"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hare-compress/";
    description = "Compression algorithms for Hare";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ starzation ];

    inherit (harec.meta) platforms badPlatforms;
  };
})
