{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libX11,
  libXext,
  libXft,
}:

let
  version = "1.40";
in
stdenv.mkDerivation {
  pname = "windowlab";
  inherit version;

  src = fetchurl {
    url = "http://nickgravgaard.com/windowlab/windowlab-${version}.tar";
    sha256 = "1fx4jwq4s98p2wpvawsiww7d6568bpjgcjpks61dzfj8p2j32s4d";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libX11
    libXext
    libXft
  ];

  postPatch = ''
    mv Makefile Makefile.orig
    echo \
       "
        DEFINES += -DXFT
        EXTRA_INC += $(pkg-config --cflags xft)
        EXTRA_LIBS += $(pkg-config --libs xft)
       " > Makefile
    sed "s|/usr/local|$out|g" Makefile.orig >> Makefile
  '';

  meta = with lib; {
    description = "Small and simple stacking window manager";
    homepage = "http://nickgravgaard.com/windowlab/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    mainProgram = "windowlab";
  };
}
