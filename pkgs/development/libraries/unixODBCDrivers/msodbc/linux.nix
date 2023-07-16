{
  dpkg,
  fetchurl,
  lib,
  libkrb5,
  libuuid ,
  openssl,
  patchelf,
  stdenv,
  unixODBC,
}:

stdenv.mkDerivation rec {
    pname = "msodbcsql17";
    version = "${versionMajor}.${versionMinor}.${versionAdditional}-1";

    versionMajor = "17";
    versionMinor = "7";
    versionAdditional = "1.1";

    src = fetchurl {
      url = "https://packages.microsoft.com/debian/10/prod/pool/main/m/msodbcsql17/msodbcsql${versionMajor}_${version}_amd64.deb";
      sha256 = "0vwirnp56jibm3qf0kmi4jnz1w7xfhnsfr8imr0c9hg6av4sk3a6";
    };

    nativeBuildInputs = [ dpkg patchelf ];

    unpackPhase = "dpkg -x $src ./";
    buildPhase = "";

    installPhase = ''
      mkdir -p $out
      mkdir -p $out/lib
      cp -r opt/microsoft/msodbcsql${versionMajor}/lib64 opt/microsoft/msodbcsql${versionMajor}/share $out/
    '';

    postFixup = ''
      patchelf --set-rpath ${lib.makeLibraryPath [ unixODBC openssl libkrb5 libuuid stdenv.cc.cc ]} \
        $out/lib/libmsodbcsql-${versionMajor}.${versionMinor}.so.${versionAdditional}
    '';

    passthru = {
      fancyName = "ODBC Driver 17 for SQL Server";
      driver = "lib/libmsodbcsql-${versionMajor}.${versionMinor}.so.${versionAdditional}";
    };

    meta = with lib; {
      broken = stdenv.isDarwin;
      description = "ODBC Driver 17 for SQL Server";
      homepage = "https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [ spencerjanssen ];
    };
  }
