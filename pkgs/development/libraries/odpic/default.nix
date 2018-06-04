{ stdenv, fetchurl, libaio, oracle-instantclient }:

stdenv.mkDerivation rec {
  name = "odpic-${version}";
  version = "2.3.2";

  src = fetchurl {
    url = "https://github.com/oracle/odpi/archive/v${version}.tar.gz";
    sha256 = "0a52vqy3c27hmcia4x4vhs6z0ha27xkw7fvfa17f7kxs5w84ll07";
  };

  buildInputs = [ libaio oracle-instantclient ];

  libPath = stdenv.lib.makeLibraryPath
    [ oracle-instantclient ];

  dontPatchELF = true;
  installPhase = ''
    mkdir -p $out/lib
    mkdir $out/include

    cp lib/* $out/lib/
    cp include/* $out/include/

    patchelf --set-rpath "${libPath}" $out/lib/libodpic.so
  '';

  meta = with stdenv.lib; {
    description = "Oracle ODPI-C library";
    homepage = "https://oracle.github.io/odpi/";
    maintainers = with maintainers; [ mkazulak ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [];
  };
}
