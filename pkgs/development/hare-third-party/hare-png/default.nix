{
  lib,
  stdenv,
  hareHook,
  hareThirdParty,
  fetchFromSourcehut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-png";
  version = "0-unstable-2023-09-09";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-png";
    rev = "9deb848ae691d784c5cc7949153cfa04c67f90b6";
    hash = "sha256-Q7xylsLVd/sp57kv6WzC7QHGN1xOsm7YEsYCbY/zi1Q=";
  };

  nativeBuildInputs = [ hareHook ];
  propagatedBuildInputs = [ hareThirdParty.hare-compress ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hare-png/";
    description = "PNG implementation for Hare";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ starzation ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
