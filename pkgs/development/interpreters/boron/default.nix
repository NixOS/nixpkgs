{ lib
, stdenv
, fetchurl
, zlib
}:

stdenv.mkDerivation rec {
  pname = "boron";
  version = "2.0.8";

  src = fetchurl {
    url = "https://sourceforge.net/projects/urlan/files/Boron/boron-${version}.tar.gz";
    sha256 = "sha256-Ni/LJgOABC2wXDMsg1ZAuZWSQdFT9/Fa4lH4+V0gy8M=";
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
    homepage = "http://urlan.sourceforge.net/boron/";
    description = "Scripting language and C library useful for building DSLs";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mausch ];
  };
}

