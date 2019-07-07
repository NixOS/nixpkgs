{ stdenv, fetchurl, autoreconfHook }:

let
    version = "0.1.3";
in
stdenv.mkDerivation {
  name = "vo-amrwbenc-${version}";
  version = "0.1.3";
  buildInputs = [ autoreconfHook ];
  src = fetchurl {
    url = "https://github.com/mstorsjo/vo-amrwbenc/archive/v${version}.tar.gz";
    sha256 = "85c79997ba7ddb9c95b5ddbe9ea032e27595390f3cbd686ed46a69e485cc053c";
  };

  meta = {
    homepage = https://sourceforge.net/projects/opencore-amr/;
    description = "VisualOn Adaptive Multi Rate Wideband (AMR-WB) encoder";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.Esteth ];
    platforms = stdenv.lib.platforms.unix;
  };
}
