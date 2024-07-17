{
  lib,
  stdenv,
  hare,
  hareThirdParty,
  fetchFromSourcehut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-png";
  version = "unstable-2023-09-09";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-png";
    rev = "9deb848ae691d784c5cc7949153cfa04c67f90b6";
    hash = "sha256-Q7xylsLVd/sp57kv6WzC7QHGN1xOsm7YEsYCbY/zi1Q=";
  };

  nativeBuildInputs = [ hare ];
  propagatedBuildInputs = [ hareThirdParty.hare-compress ];

  makeFlags = [
    "PREFIX=${builtins.placeholder "out"}"
    "HARECACHE=.harecache"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hare-png/";
    description = "PNG implementation for Hare";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ starzation ];

    inherit (hare.meta) platforms badPlatforms;
  };
})
