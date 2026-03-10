{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vdmfec";
  version = "1.0";

  src = fetchurl {
    url = "http://members.tripod.com/professor_tom/archives/vdmfec-${finalAttrs.version}.tgz";
    sha256 = "0i7q4ylx2xmzzq778anpkj4nqir5gf573n1lbpxnbc10ymsjq2rm";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    description = "Program that adds error correction blocks";
    homepage = "http://members.tripod.com/professor_tom/archives/index.html";
    maintainers = [ lib.maintainers.ar1a ];
    license = with lib.licenses; [
      gpl2 # for vdmfec
      bsd2 # for fec
    ];
    platforms = lib.platforms.all;
  };
})
