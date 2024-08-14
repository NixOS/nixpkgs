{ lib
, stdenv
, fetchurl
, zlib
}:

stdenv.mkDerivation rec {
  pname = "boron";
  version = "2.1.0";

  src = fetchurl {
    url = "https://sourceforge.net/projects/urlan/files/Boron/boron-${version}.tar.gz";
    sha256 = "sha256-50HKcK2hQpe9k9RIoVa/N5krTRKlW9AsGYTmHITx7Nc=";
  };

  # this is not a standard Autotools-like `configure` script
  dontAddPrefix = true;

  preConfigure = ''
    patchShebangs configure
  '';

  configureFlags = [ "--thread" ];

  makeFlags = [ "DESTDIR=$(out)" ];

  buildInputs = [
    zlib
  ];

  installTargets = [ "install" "install-dev" ];

  doCheck = true;

  checkPhase = ''
    patchShebangs .
    make -C test
  '';

  meta = with lib; {
    homepage = "https://urlan.sourceforge.net/boron/";
    description = "Scripting language and C library useful for building DSLs";
    mainProgram = "boron";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mausch ];
  };
}

