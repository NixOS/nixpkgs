{ stdenv, fetchFromGitHub, which, vapoursynth }:

stdenv.mkDerivation rec {
  pname = "vapoursynth-bilateral";
  version = "r3";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-Bilateral";
    rev = version;
    sha256 = "05rhbg84z74rk3jcxa6abgqcqnjzgmjw03wljxa55jc358h9a6f0";
  };

  preConfigure = "chmod +x configure";
  dontAddPrefix = true;
  configureFlags = [ "--install=$(out)/lib/vapoursynth" ];

  nativeBuildInputs = [ which ];
  buildInputs = [ vapoursynth ];

  meta = with stdenv.lib; {
    description = "Bilateral filter for VapourSynth";
    homepage = https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Bilateral;
    license = licenses.gpl3;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
