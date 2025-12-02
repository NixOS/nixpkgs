{
  fetchFromSourcehut,
  hareHook,
  harec,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-json";
  version = "0-unstable-2024-04-19";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-json";
    rev = "b6aeae96199607a1f3b4d437d5c99f821bd6a6b6";
    hash = "sha256-mgUzHGXbaJdWm7qUn7mWdDUQBgbEjh42O+Lo0ok80Wo=";
  };

  nativeBuildInputs = [ hareHook ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hare-json/";
    description = "This package provides JSON support for Hare";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ starzation ];
    inherit (harec.meta) platforms badPlatforms;
  };
})
