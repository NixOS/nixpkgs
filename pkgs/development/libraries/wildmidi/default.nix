{ lib, stdenv, fetchFromGitHub, cmake, alsa-lib, freepats }:

stdenv.mkDerivation rec {
  pname = "wildmidi";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "Mindwerks";
    repo = "wildmidi";
    rev = "${pname}-${version}";
    sha256 = "08fbbsvw6pkwwqarjwcvdp8mq4zn5sgahf025hynwc6rvf4sp167";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ alsa-lib stdenv.cc.libc/*couldn't find libm*/ ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace /etc/wildmidi $out/etc
    # https://github.com/Mindwerks/wildmidi/issues/236
    substituteInPlace src/wildmidi.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  postInstall = ''
    mkdir "$out"/etc
    echo "dir ${freepats}" > "$out"/etc/wildmidi.cfg
    echo "source ${freepats}/freepats.cfg" >> "$out"/etc/wildmidi.cfg
  '';

  meta = with lib; {
    description = "Software MIDI player and library";
    longDescription = ''
      WildMIDI is a simple software midi player which has a core softsynth
      library that can be use with other applications.
    '';
    homepage = "https://wildmidi.sourceforge.net/";
    # The library is LGPLv3, the wildmidi executable is GPLv3
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
