{
  fetchFromSourcehut,
  hareHook,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-json";
  version = "0.26.0.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-json";
    tag = finalAttrs.version;
    hash = "sha256-vAT10QGFwazM5PYLQpW0ebFGa2sScXWM87jzI+m4/eM=";
  };

  nativeBuildInputs = [ hareHook ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = {
    homepage = "https://git.sr.ht/~sircmpwn/hare-json/";
    description = "This package provides JSON support for Hare";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ starzation ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
