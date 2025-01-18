{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  version = "3.8";
  pname = "xtermcontrol";

  src = fetchurl {
    url = "https://thrysoee.dk/xtermcontrol/xtermcontrol-${version}.tar.gz";
    sha256 = "sha256-Vh6GNiDkjNhaD9U/3fG2LpMLN39L3jRUgG/FQeG1z40=";
  };

  meta = with lib; {
    description = "Enables dynamic control of xterm properties";
    longDescription = ''
      Enables dynamic control of xterm properties.
      It makes it easy to change colors, title, font and geometry of a running xterm, as well as to report the current settings of these properties.
      Window manipulations de-/iconify, raise/lower, maximize/restore and reset are also supported.
      To complete the feature set; xtermcontrol lets advanced users issue any xterm control sequence of their choosing.
    '';
    homepage = "http://thrysoee.dk/xtermcontrol";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.derchris ];
    mainProgram = "xtermcontrol";
  };
}
