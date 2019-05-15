{ stdenv, fetchFromGitHub, vapoursynth }:

let
  ext = stdenv.targetPlatform.extensions.sharedLibrary;
in stdenv.mkDerivation rec {
  pname = "vapoursynth-beziercurve";
  version = "r2";

  src = fetchFromGitHub {
    owner = "kewenyu";
    repo = "VapourSynth-BezierCurve";
    rev = version;
    sha256 = "0c96gqa3f2wrm2d22q9qwqq3mk8jir7dl4chxqb2kpcjv4wh3xjg";
  };

  buildInputs = [ vapoursynth ];

  patchPhase = ''
    substituteInPlace VapourSynth-BezierCurve/BezierCurve.h \
        --replace '<vapoursynth\' '<vapoursynth/'
  '';

  buildPhase = ''
    c++ -fPIC -shared -I${vapoursynth.dev}/include/vapoursynth \
        -o VapourSynth-BezierCurve${ext} \
	      VapourSynth-BezierCurve/BezierCurve.cpp \
        VapourSynth-BezierCurve/CubicBezierCurve.cpp \
        VapourSynth-BezierCurve/QuadraticBezierCurve.cpp \
        VapourSynth-BezierCurve/VapourSynth-BezierCurve.cpp
  '';

  installPhase = ''
    install -D VapourSynth-BezierCurve${ext} $out/lib/vapoursynth/VapourSynth-BezierCurve${ext}
  '';

  meta = with stdenv.lib; {
    description = "A bézier curve plugin for VapourSynth";
    homepage = https://github.com/kewenyu/VapourSynth-BezierCurve;
    license = licenses.mit;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.all;
  };
}
