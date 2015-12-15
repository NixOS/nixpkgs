{ stdenv, which, coreutils, fetchzip, qt4 }:

stdenv.mkDerivation rec {
  name = "qxt-${version}";
  version = "0.6.2";
  
  src = fetchzip {
    url = "https://bitbucket.org/libqxt/libqxt/get/v${version}.tar.gz";
    sha256 = "0zmqfn0h8cpky7wgaaxlfh0l89r9r0isi87587kaicyap7a6kxwz";
  };

  buildInputs = [ qt4 which ];

  patchPhase = ''
    patchShebangs configure
    substituteInPlace configure --replace "/bin/pwd" "${coreutils}/bin/pwd"
  '';

  prefixKey = "-prefix ";

  meta = {
    homepage = http://libqxt.org;
    description = "An extension library for Qt";
    longDescription = ''
      An extension library for Qt providing a suite of cross-platform utility
      classes to add functionality not readily available in the Qt toolkit by Qt
      Development Frameworks, Nokia.
    '';
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ forkk ];
  };
}
