{
  cryptopp,
  curl,
  fetchzip,
  fuse,
  lib,
  pkg-config,
  sqlite,
  stdenv,
  withMountVhd ? false,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "urbackup-server";
  version = "2.5.33";

  src = fetchzip {
    url = "https://hndl.urbackup.org/Server/${version}/urbackup-server-${version}.tar.gz";
    hash = "sha256-XfVQaeenNvQwf0WsWSnUKR5SrdsSGho7UhhXmoHWoYU=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cryptopp
    curl
    sqlite
    zlib
  ] ++ lib.optionals (withMountVhd) [ fuse ];

  configureFlags = [
    "--with-crypto-prefix=${cryptopp.dev}"
    "--enable-packaging"
  ] ++ lib.optionals (withMountVhd) [ "--with-mountvhd" ];

  enableParallelBuilding = true;

  postPatch = ''
    # prevent chmod failure. setuid is set in the service.
    substituteInPlace Makefile.in \
    --replace-fail "chmod +s" "# chmod +s"

    # Adjust statedir at compile time for systemd service.
    substituteInPlace Makefile.in \
    --replace-fail "-DVARDIR='\"\$(localstatedir)\"'"  "-DVARDIR='\"/var/lib\"'"
  '';

  meta = {
    description = "Easy to setup Open Source client/server backup system";
    longDescription = "An easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time";
    homepage = "https://www.urbackup.org/index.html";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ quincepie ];
  };
}
