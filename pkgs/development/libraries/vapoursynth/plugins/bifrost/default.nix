{ stdenv, fetchFromGitHub, autoreconfHook, pkg-config, vapoursynth }:

stdenv.mkDerivation rec {
  pname = "vapoursynth-bifrost";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ivmxgqfp9d6axvznkjcckv6ajvs0advx6iisvry52pfc8lprbp8";
  };

  configureFlags = [ "--libdir=$(out)/lib/vapoursynth" ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ vapoursynth ];

  meta = with stdenv.lib; {
    description = "Bifrost (temporal derainbowing) plugin for Vapoursynth";
    homepage = https://github.com/dubhater/vapoursynth-bifrost;
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
