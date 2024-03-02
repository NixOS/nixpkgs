{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, cmake
, cppzmq
, doxygen
, ffmpeg
, imagemagick
, jsoncpp
, libopenshot-audio
, llvmPackages
, pkg-config
, python3
, qtbase
, qtmultimedia
, swig
, zeromq
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenshot";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot";
    rev = "v${finalAttrs.version}";
    hash = "sha256-axFGNq+Kg8atlaSlG8EKvxj/FwLfpDR8/e4otmnyosM=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # Darwin requires both Magick++ and MagickCore for a successful linkage
    ./0001-link-magickcore.diff
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    swig
  ];

  buildInputs = [
    cppzmq
    ffmpeg
    imagemagick
    jsoncpp
    libopenshot-audio
    python3
    qtbase
    qtmultimedia
    zeromq
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    llvmPackages.openmp
  ];

  strictDeps = true;

  dontWrapQtApps = true;

  doCheck = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_RUBY" false)
    (lib.cmakeOptionType "filepath" "PYTHON_MODULE_PATH" python3.sitePackages)
  ];

  passthru = {
    inherit libopenshot-audio;
  };

  meta = {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor library";
    longDescription = ''
      OpenShot Library (libopenshot) is an open-source project dedicated to
      delivering high quality video editing, animation, and playback solutions
      to the world. API currently supports C++, Python, and Ruby.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
