{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libcaca,
  toilet,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toilet";
  version = "0.3";

  src = fetchurl {
    url = "http://caca.zoy.org/raw-attachment/wiki/toilet/toilet-${finalAttrs.version}.tar.gz";
    sha256 = "1pl118qb7g0frpgl9ps43w4sd0psjirpmq54yg1kqcclqcqbbm49";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libcaca ];

  passthru.tests.version = testers.testVersion {
    package = toilet;
  };

  meta = {
    description = "Display large colourful characters in text mode";
    homepage = "http://caca.zoy.org/wiki/toilet";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.all;
    mainProgram = "toilet";
  };
})
