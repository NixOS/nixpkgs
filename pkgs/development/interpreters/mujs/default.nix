{ lib
, stdenv
, fetchurl
, fixDarwinDylibNames
, readline
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "mujs";
  version = "1.3.4";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${version}.tar.gz";
    hash = "sha256-wBVHWID2o4LnBhaclDcafdbMIgeIMvbghlr4KJwu9Cs=";
  };

  buildInputs = [ readline ];

  nativeBuildInputs = lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];

  makeFlags = [ "prefix=$(out)" ];

  installFlags = [ "install-shared" ];

  passthru.updateScript = gitUpdater {
    # No nicer place to track releases
    url = "git://git.ghostscript.com/mujs.git";
  };

  meta = with lib; {
    homepage = "https://mujs.com/";
    description = "Lightweight, embeddable Javascript interpreter";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    license = licenses.isc;
  };
}
