{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, wafHook
, python3
, pkg-config
, openssl
, boost
, libxmlxx
, xmlsec
, libxslt
, graphicsmagick
, libsndfile
, openjpeg
, asdcplib-carl
, libcxml
, xercesc
, libtool
, libsigcxx
, llvmPackages
, dcpomatic
}:

let
  openjpeg-patched = openjpeg.overrideAttrs (origAttrs: {
    patches = (origAttrs.patches or [ ]) ++ [
      (fetchpatch {
        url = "https://github.com/cth103/openjpeg/commit/a1403c2e2e71c6252d97abf9ddca421ce925d456.patch";
        sha256 = "1vc77rnw6yc3drksp6wzii9lw3jg0ykjw446s90ym2h52mhjr45x";
      })
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "libdcp";
  version = "unstable-20220116";

  src = fetchFromGitHub {
    owner = "cth103";
    repo = "libdcp";
    rev = "81c6fcba23f5c037f52c3324f4134e81d4f5d5c6";
    sha256 = "1ay89xb99p5f74k9w8k9bil26a11vwyy1ap7jgv7mbgchdq0dy2l";
  };

  postPatch = ''
    substituteInPlace wscript \
      --replace "this_version = " "this_version = 'v${version}' #" \
      --replace "last_version = " "last_version = 'v${version}' #"
  '';

  wafConfigureFlags = [
    # Tests require private non-distributable data.
    "--disable-tests"
    "--disable-benchmarks"

    "--enable-openmp"
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [
    asdcplib-carl
    openssl
    xercesc
    xmlsec
    libxmlxx
    libsigcxx
    libxslt
  ];

  buildInputs = [
    boost
    graphicsmagick
    libsndfile
    openjpeg-patched
    libcxml
    libtool
  ] ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  nativeBuildInputs = [
    wafHook
    python3
    pkg-config
  ];

  passthru.tests = {
    # Changes to libdcp should basically always ensure dcpomatic continues to build.
    inherit dcpomatic;
  };

  meta = with lib; {
    description = "Library to read and write Digital Cinema Packages using JPEG2000 and PCM data, including KDMs";
    homepage = "https://carlh.net/libdcp";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lukegb ];
  };
}
