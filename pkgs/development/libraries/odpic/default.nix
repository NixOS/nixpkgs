{ stdenv, fetchurl, fixDarwinDylibNames, oracle-instantclient, libaio }:

stdenv.mkDerivation rec {
  name = "odpic-${version}";
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/oracle/odpi/archive/v${version}.tar.gz";
    sha256 = "0m6g7lbvfir4amf2cnap9wz9fmqrihqpihd84igrd7fp076894c0";
  };

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin [ fixDarwinDylibNames ];

  buildInputs = [ oracle-instantclient ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libaio ];

  libPath = stdenv.lib.makeLibraryPath
    [ oracle-instantclient ];

  dontPatchELF = true;
  makeFlags = [ "PREFIX=$(out)" "CC=cc" "LD=cc"];

  postFixup = ''
    ${stdenv.lib.optionalString (stdenv.isLinux) ''
      patchelf --set-rpath "${libPath}" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
    ''}
    ${stdenv.lib.optionalString (stdenv.isDarwin) ''
      install_name_tool -add_rpath "${libPath}" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
    ''}
    '';

  meta = with stdenv.lib; {
    description = "Oracle ODPI-C library";
    homepage = "https://oracle.github.io/odpi/";
    maintainers = with maintainers; [ mkazulak flokli ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    hydraPlatforms = [];
  };
}
