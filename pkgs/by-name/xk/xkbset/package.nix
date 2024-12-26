{
  lib,
  stdenv,
  fetchurl,
  perl,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "xkbset";
  version = "0.6";

  src = fetchurl {
    url = "http://faculty.missouri.edu/~stephen/software/xkbset/xkbset-${version}.tar.gz";
    sha256 = "sha256-rAMv7EnExPDyMY0/RhiXDFFBkbFC4GxRpmH+I0KlNaU=";
  };

  buildInputs = [
    perl
    libX11
  ];

  postPatch = ''
    sed "s:^X11PREFIX=.*:X11PREFIX=$out:" -i Makefile
  '';

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
  '';

  postInstall = ''
    rm -f $out/bin/xkbset-gui
  '';

  meta = with lib; {
    homepage = "http://faculty.missouri.edu/~stephen/software/#xkbset";
    description = "Program to help manage many of XKB features of X window";
    maintainers = with maintainers; [ drets ];
    platforms = platforms.linux;
    license = licenses.bsd3;
    mainProgram = "xkbset";
  };
}
