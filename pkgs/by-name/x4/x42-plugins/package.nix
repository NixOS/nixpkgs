{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libltc,
  libsndfile,
  libsamplerate,
  ftgl,
  freefont_ttf,
  libjack2,
  libGLU,
  lv2,
  cairo,
  pango,
  fftwFloat,
  zita-convolver,
}:

stdenv.mkDerivation rec {
  pname = "x42-plugins";
  version = "20260125";

  src = fetchurl {
    url = "https://gareus.org/misc/x42-plugins/${pname}-${version}.tar.xz";
    hash = "sha256-wcIShcFc91BVZQ1rz55+AN+7R5b0fClOzT1thXSz1ug=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libGLU
    ftgl
    freefont_ttf
    libjack2
    libltc
    libsndfile
    libsamplerate
    lv2
    cairo
    pango
    fftwFloat
    zita-convolver
  ];

  # Don't remove this. The default fails with 'do not know how to unpack source archive'
  # every now and then on Hydra. No idea why.
  unpackPhase = ''
    tar xf $src
    sourceRoot=$(echo x42-plugins-*)
    chmod -R u+w $sourceRoot
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "FONTFILE=${freefont_ttf}/share/fonts/truetype/FreeSansBold.ttf"
  ];

  patchPhase = ''
    patchShebangs ./stepseq.lv2/gridgen.sh
    patchShebangs ./matrixmixer.lv2/genttl.sh
    patchShebangs ./matrixmixer.lv2/genhead.sh
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Collection of LV2 plugins by Robin Gareus";
    homepage = "https://github.com/x42/x42-plugins";
    maintainers = with lib.maintainers; [
      magnetophon
    ];
    license = lib.licenses.gpl2;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
