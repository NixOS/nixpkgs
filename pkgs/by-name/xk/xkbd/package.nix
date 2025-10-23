{
  lib,
  stdenv,
  fetchFromGitHub,
  freetype,
  libXrender,
  libXft,
  xorgproto,
  xinput,
  libXi,
  libXext,
  libXtst,
  libXpm,
  libX11,
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
    libXrender
    libXft
    libXext
    libXtst
    libXpm
    libX11
    libXi
    xorgproto
    xinput
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/mahatma-kaganovich/xkbd";
    description = "On-screen soft keyboard for X11";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "xkbd";
  };
}
