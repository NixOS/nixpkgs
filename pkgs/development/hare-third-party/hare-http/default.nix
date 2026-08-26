{
  fetchFromSourcehut,
  hareHook,
  hareThirdParty,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-http";
  version = "0.26.0.1";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-http";
    tag = finalAttrs.version;
    hash = "sha256-REpU2vqec758lRAXslY36xBmNdrvlvXIRv/n44G7Pn4=";
  };

  nativeBuildInputs = [ hareHook ];
  propagatedBuildInputs = [ hareThirdParty.hare-ev ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  meta = {
    homepage = "https://git.sr.ht/~sircmpwn/hare-http/";
    description = "HTTP(s) support for Hare";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ sikmir ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
