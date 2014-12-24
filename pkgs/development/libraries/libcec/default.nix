{ stdenv, fetchurl, autoreconfHook, pkgconfig, udev, makeWrapper }:

let version = "2.2.0"; in

stdenv.mkDerivation {
  name = "libcec-${version}";

  src = fetchurl {
    url = "https://github.com/Pulse-Eight/libcec/archive/libcec-${version}.tar.gz";
    sha256 = "05r9ln52mlcsw0mf66klq9gjlazf0w12hcaqdyg4n3vfinhlfkzx";
  };

  buildInputs = [ autoreconfHook pkgconfig udev makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cec-client --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = with stdenv.lib; {
    description = "libCEC allows you in combination with the right hardware to control your device with your TV remote control. Utilising your existing HDMI cabling";
    homepage = http://libcec.pulse-eight.com;
    repositories.git = https://github.com/Pulse-Eight/libcec.git;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
