{ stdenv, fetchurl, libaio, oracle-instantclient }:

stdenv.mkDerivation rec {
  name = "odpic-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/oracle/odpi/archive/v${version}.tar.gz";
    sha256 = "1z793mg8hmy067xhllip7ca84xy07ca1cqilnr35mbvhmydp03zz";
  };

  buildInputs = [ libaio oracle-instantclient ];

  libPath = stdenv.lib.makeLibraryPath
    [ oracle-instantclient ];

  dontPatchELF = true;
  makeFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    patchelf --set-rpath "${libPath}" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
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
