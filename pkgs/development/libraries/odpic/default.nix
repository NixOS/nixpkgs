{ stdenv, fetchurl, fetchpatch, fixDarwinDylibNames, oracle-instantclient, libaio }:

stdenv.mkDerivation rec {
  name = "odpic-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/oracle/odpi/archive/v${version}.tar.gz";
    sha256 = "1z793mg8hmy067xhllip7ca84xy07ca1cqilnr35mbvhmydp03zz";
  };

  patches = [ (fetchpatch {
    url = https://github.com/oracle/odpi/commit/31fdd70c06be711840a2668f572c7ee7c4434d18.patch;
    sha256 = "1f00zp4w7l4vnkg0fmvnkga20ih8kjd5bxvr1nryziibjh1xp41j";
  }) ];

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
