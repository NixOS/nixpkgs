{ cairo
, cmake
, fetchFromGitHub
, ffmpeg
, freetype
, ghostscript
, glfw
, lib
, libjpeg
, libtiff
, nix-update-script
, qhull
, qtbase
, stdenv
, wrapQtAppsHook
, xorg
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "gr-framework";
  version = "0.72.9";

  src = fetchFromGitHub {
    owner = "sciapp";
    repo = "gr";
    rev = "v${version}";
    hash = "sha256-4rOcrMn0sxTeRQqiQMAWULzUV39i6J96Mb096Lyblns=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    cairo
    ffmpeg
    freetype
    ghostscript
    glfw
    libjpeg
    libtiff
    qhull
    qtbase
    xorg.libX11
    xorg.libXft
    xorg.libXt
    zeromq
  ];

  preConfigure = ''
    echo ${version} > version.txt
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GR framework is a graphics library for visualisation applications";
    homepage = "https://gr-framework.org";
    maintainers = [ lib.maintainers.paveloom ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
