{
  lib,
  stdenv,
  fetchFromGitHub,
  freetype,
  libxrender,
  libxft,
  xorgproto,
  xinput,
  libxi,
  libxext,
  libxtst,
  libxpm,
  libx11,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "xkbd";
  version = "0.8.18";

  src = fetchFromGitHub {
    owner = "mahatma-kaganovich";
    repo = "xkbd";
    rev = "${pname}-${version}";
    sha256 = "05ry6q75jq545kf6p20nhfywaqf2wdkfiyp6iwdpv9jh238hf7m9";
  };

  buildInputs = [
    freetype
    libxrender
    libxft
    libxext
    libxtst
    libxpm
    libx11
    libxi
    xorgproto
    xinput
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/mahatma-kaganovich/xkbd";
    description = "On-screen soft keyboard for X11";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "xkbd";
  };
}
