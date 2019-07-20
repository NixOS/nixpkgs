{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, libsndfile }:

stdenv.mkDerivation rec {

  name = "twolame-${version}";
  version = "2017-09-27";

  src = fetchFromGitHub {
    owner = "njh";
    repo = "twolame";
    rev = "977c8ac55d8ca6d5f35d1d413a119dac2b3b0333";
    sha256 = "1rq3yc8ygzdqid9zk6pixmm4w9sk2vrlx217lhn5bjaglv7iyf7x";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libsndfile ];

  doCheck = false; # fails with "../build-scripts/test-driver: line 107: -Mstrict: command not found"

  meta = with stdenv.lib;{
    description = "A MP2 encoder";
    longDescription = ''
      TwoLAME is an optimised MPEG Audio Layer 2 (MP2) encoder based on
      tooLAME by Mike Cheng, which in turn is based upon the ISO dist10
      code and portions of LAME.
    '';
    homepage = http://www.twolame.org/;
    license = with licenses; [ lgpl2Plus ];
    platforms = with platforms; unix;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
