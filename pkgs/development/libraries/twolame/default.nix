{ stdenv, fetchFromGitHub
, autoreconfHook
, pkgconfig
, libsndfile, xmlto, asciidoc }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "twolame";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "njh";
    repo = "twolame";
    rev = version;
    sha256 = "0ckwdx5kmgmh1jq2wl6c9d57pf6z6p2wjdy6fw01a8f3clg21a8g";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig xmlto asciidoc ];
  buildInputs = [ libsndfile ];

  doCheck = false; # fails with "../build-scripts/test-driver: line 107: -Mstrict: command not found"

  meta = {
    description = "A MP2 encoder";
    longDescription = ''
      TwoLAME is an optimised MPEG Audio Layer 2 (MP2) encoder based on
      tooLAME by Mike Cheng, which in turn is based upon the ISO dist10
      code and portions of LAME.
    '';
    homepage = "http://www.twolame.org/";
    license = with licenses; [ lgpl2Plus ];
    platforms = with platforms; unix;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
