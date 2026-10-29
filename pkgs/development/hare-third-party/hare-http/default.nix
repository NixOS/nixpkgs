{
  fetchFromSourcehut,
  hareHook,
  hareThirdParty,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-http";
  version = "0.26.0.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-http";
    tag = finalAttrs.version;
    hash = "sha256-0NPLYuoAVvIiDH7d0KtJnmKX/C1ShdBZIo9w3EPsmkA=";
  };

  nativeBuildInputs = [ hareHook ];
  propagatedBuildInputs = [ hareThirdParty.hare-ev ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = {
    homepage = "https://git.sr.ht/~sircmpwn/hare-http/";
    description = "HTTP(s) support for Hare";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ sikmir ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
