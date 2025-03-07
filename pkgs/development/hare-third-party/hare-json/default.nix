{
  fetchFromSourcehut,
  hareHook,
  harec,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-json";
  version = "0-unstable-2023-03-13";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-json";
    rev = "88256102a9fec62d494628e32cb406574e49e5e1";
    hash = "sha256-Sx+RBiLhR3ftP89AwinVlBg0u0HX4GVP7TLmuofgC9s=";
  };

  nativeBuildInputs = [ hareHook ];

  makeFlags = [ "PREFIX=${builtins.placeholder "out"}" ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hare-json/";
    description = "This package provides JSON support for Hare";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ starzation ];
    inherit (harec.meta) platforms badPlatforms;
  };
})
