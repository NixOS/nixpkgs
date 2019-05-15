{ stdenv, fetchFromGitHub, meson, ninja, pkg-config, vapoursynth, fftwSinglePrec }:

stdenv.mkDerivation rec {
  pname = "vapoursynth-bm3d";
  version = "r8";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-BM3D";
    rev = version;
    sha256 = "0hifiyqr0vp3rkqrjbz2fvka7s8xvcpl58rjf0rvljs64bxia4v7";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ vapoursynth fftwSinglePrec ];

  # i could not find a way to override the default meson install dir.
  # patching the file didn't work
  installPhase =
    let
      ext = stdenv.targetPlatform.extensions.sharedLibrary;
    in ''
      install -D libbm3d${ext} $out/lib/vapoursynth/libbm3d${ext}
    '';

  meta = with stdenv.lib; {
    description = "BM3D denoising filter for VapourSynth";
    homepage = https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D;
    license = licenses.mit;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
