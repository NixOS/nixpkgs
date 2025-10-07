{
  config,
  fetchpatch,
  fetchurl,
  stdenv,
  unixODBC,
  cmake,
  mariadb,
  sqlite,
  zlib,
  libxml2,
  dpkg,
  lib,
  openssl,
  libkrb5,
  libuuid,
  patchelf,
  libiconv,
  fixDarwinDylibNames,
  fetchFromGitHub,
  psqlodbc,
}:

# Each of these ODBC drivers can be configured in your odbcinst.ini file using
# the various passthru and meta values. Of note are:
#
#   * `passthru.fancyName`, the typical name used to reference the driver
#   * `passthru.driver`, the path to the driver within the built package
#   * `meta.description`, a short description of the ODBC driver
#
# For example, you might generate it as follows:
#
# ''
# [${package.fancyName}]
# Description = ${package.meta.description}
# Driver = ${package}/${package.driver}
# ''

{
  psql = psqlodbc.override {
    withUnixODBC = true;
    withLibiodbc = false;
  };

  mariadb = stdenv.mkDerivation rec {
    pname = "mariadb-connector-odbc";
    version = "3.2.6";

    src = fetchFromGitHub {
      owner = "mariadb-corporation";
      repo = "mariadb-connector-odbc";
      rev = version;
      hash = "sha256-FdnA3/xDxnk2910LCMPWQTcUUSYfUsnnZ3Hqj0uey5s=";
      # this driver only seems to build correctly when built against the mariadb-connect-c subrepo
      # (see https://github.com/NixOS/nixpkgs/issues/73258)
      fetchSubmodules = true;
    };

    patches = [
      # Fix `call to undeclared function 'sleep'` with clang 16
      ./mariadb-connector-odbc-unistd.patch

      ./mariadb-connector-odbc-musl.patch

      # Fix build with gcc15
      # https://github.com/mariadb-corporation/mariadb-connector-odbc/pull/63
      (fetchpatch {
        name = "mariadb-connector-odbc-add-include-cstdint-gcc15.patch";
        url = "https://github.com/mariadb-corporation/mariadb-connector-odbc/commit/a3ced654db2ef93de0a818f2d66171f6084e5f2d.patch";
        hash = "sha256-GZITSryfRdAgNxZehasoBModGNZo575Dd5aokwNWzpY=";
      })
    ];

    nativeBuildInputs = [ cmake ];
    buildInputs = [
      unixODBC
      openssl
      libiconv
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libkrb5 ];

    cmakeFlags = [
      "-DWITH_EXTERNAL_ZLIB=ON"
      "-DODBC_LIB_DIR=${lib.getLib unixODBC}/lib"
      "-DODBC_INCLUDE_DIR=${lib.getDev unixODBC}/include"
      "-DWITH_OPENSSL=ON"
      # on darwin this defaults to ON but we want to build against unixODBC
      "-DWITH_IODBC=OFF"
    ];

    buildFlags = if stdenv.hostPlatform.isDarwin then [ "maodbc" ] else null;

    env = lib.optionalAttrs stdenv.cc.isGNU {
      NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
    };

    installTargets = if stdenv.hostPlatform.isDarwin then [ "install/fast" ] else null;

    # see the top of the file for an explanation
    passthru = {
      fancyName = "MariaDB";
      driver = "lib/libmaodbc${stdenv.hostPlatform.extensions.sharedLibrary}";
    };

    meta = with lib; {
      description = "MariaDB ODBC database driver";
      homepage = "https://downloads.mariadb.org/connector-odbc/";
      license = licenses.gpl2;
      platforms = platforms.linux ++ platforms.darwin;
    };
  };

  sqlite = stdenv.mkDerivation rec {
    pname = "sqlite-connector-odbc";
    version = "0.9993";

    src = fetchurl {
      url = "http://www.ch-werner.de/sqliteodbc/sqliteodbc-${version}.tar.gz";
      sha256 = "0dgsj28sc7f7aprmdd0n5a1rmcx6pv7170c8dfjl0x1qsjxim6hs";
    };

    patches = [
      # Fix build with gcc15
      (fetchpatch {
        name = "sqlite-connector-odbc-fix-incompatible-pointer-compilation-error.patch";
        url = "https://src.fedoraproject.org/rpms/sqliteodbc/raw/e3d93f5909c884fd8846b36b71ba67a3ad65da2a/f/sqliteodbc-0.99991-Fix-incompatible-pointer-compilation-error.patch";
        hash = "sha256-IAZDujEkAyU40sKa4GC+upURNt7vplCDAx91Eeny+bU=";
      })
    ];

    buildInputs = [
      unixODBC
      sqlite
      zlib
      libxml2
    ];

    configureFlags = [
      "--with-odbc=${unixODBC}"
      "--with-sqlite3=${sqlite.dev}"
    ];

    installTargets = [ "install-3" ];

    # move libraries to $out/lib where they're expected to be
    postInstall = ''
      mkdir -p "$out/lib"
      mv "$out"/*.* "$out/lib"
    '';

    # see the top of the file for an explanation
    passthru = {
      fancyName = "SQLite";
      driver = "lib/libsqlite3odbc.so";
    };

    meta = with lib; {
      description = "ODBC driver for SQLite";
      homepage = "http://www.ch-werner.de/sqliteodbc";
      license = licenses.bsd2;
      platforms = platforms.unix;
      maintainers = with maintainers; [ vlstill ];
    };
  };

  msodbcsql17 = stdenv.mkDerivation rec {
    pname = "msodbcsql17";
    version = "${versionMajor}.${versionMinor}.${versionAdditional}-1";

    versionMajor = "17";
    versionMinor = "7";
    versionAdditional = "1.1";

    src = fetchurl {
      url = "https://packages.microsoft.com/debian/10/prod/pool/main/m/msodbcsql17/msodbcsql${versionMajor}_${version}_amd64.deb";
      sha256 = "0vwirnp56jibm3qf0kmi4jnz1w7xfhnsfr8imr0c9hg6av4sk3a6";
    };

    nativeBuildInputs = [
      dpkg
      patchelf
    ];

    unpackPhase = "dpkg -x $src ./";
    buildPhase = "";

    installPhase = ''
      mkdir -p $out
      mkdir -p $out/lib
      cp -r opt/microsoft/msodbcsql${versionMajor}/lib64 opt/microsoft/msodbcsql${versionMajor}/share $out/
    '';

    postFixup = ''
      patchelf --set-rpath ${
        lib.makeLibraryPath [
          unixODBC
          openssl
          libkrb5
          libuuid
          stdenv.cc.cc
        ]
      } \
        $out/lib/libmsodbcsql-${versionMajor}.${versionMinor}.so.${versionAdditional}
    '';

    # see the top of the file for an explanation
    passthru = {
      fancyName = "ODBC Driver ${versionMajor} for SQL Server";
      driver = "lib/libmsodbcsql-${versionMajor}.${versionMinor}.so.${versionAdditional}";
    };

    meta = with lib; {
      broken = stdenv.hostPlatform.isDarwin;
      description = "ODBC Driver ${versionMajor} for SQL Server";
      homepage = "https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [ spencerjanssen ];
    };
  };

  msodbcsql18 = stdenv.mkDerivation (finalAttrs: {
    pname = "msodbcsql${finalAttrs.versionMajor}";
    version = "${finalAttrs.versionMajor}.${finalAttrs.versionMinor}.${finalAttrs.versionAdditional}${finalAttrs.versionSuffix}";

    versionMajor = "18";
    versionMinor = "1";
    versionAdditional = "1.1";
    versionSuffix = lib.optionalString stdenv.hostPlatform.isLinux "-1";

    src = fetchurl {
      url =
        {
          x86_64-linux = "https://packages.microsoft.com/debian/11/prod/pool/main/m/msodbcsql${finalAttrs.versionMajor}/msodbcsql${finalAttrs.versionMajor}_${finalAttrs.version}_amd64.deb";
          aarch64-linux = "https://packages.microsoft.com/debian/11/prod/pool/main/m/msodbcsql${finalAttrs.versionMajor}/msodbcsql${finalAttrs.versionMajor}_${finalAttrs.version}_arm64.deb";
          x86_64-darwin = "https://download.microsoft.com/download/6/4/0/64006503-51e3-44f0-a6cd-a9b757d0d61b/msodbcsql${finalAttrs.versionMajor}-${finalAttrs.version}-amd64.tar.gz";
          aarch64-darwin = "https://download.microsoft.com/download/6/4/0/64006503-51e3-44f0-a6cd-a9b757d0d61b/msodbcsql${finalAttrs.versionMajor}-${finalAttrs.version}-arm64.tar.gz";
        }
        .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
      hash =
        {
          x86_64-linux = "sha256:1f0rmh1aynf1sqmjclbsyh2wz5jby0fixrwz71zp6impxpwvil52";
          aarch64-linux = "sha256:0zphnbvkqdbkcv6lvv63p7pyl68h5bs2dy6vv44wm6bi89svms4a";
          x86_64-darwin = "sha256:1fn80byn1yihflznxcm9cpj42mpllnz54apnk9n46vzm2ng2lj6d";
          aarch64-darwin = "sha256:116xl8r2apr5b48jnq6myj9fwqs88yccw5176yfyzh4534fznj5x";
        }
        .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
    };

    nativeBuildInputs =
      if stdenv.hostPlatform.isDarwin then
        [
          # Fix up the names encoded into the dylib, and make them absolute.
          fixDarwinDylibNames
        ]
      else
        [
          dpkg
          patchelf
        ];

    unpackPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
      dpkg -x $src ./
    '';

    installPhase =
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out
          tar xf $src --strip-components=1 -C $out
        ''
      else
        ''
          mkdir -p $out
          mkdir -p $out/lib
          cp -r opt/microsoft/msodbcsql${finalAttrs.versionMajor}/lib64 opt/microsoft/msodbcsql${finalAttrs.versionMajor}/share $out/
        '';

    # Replace the hard-coded paths in the dylib with nixpkgs equivalents.
    fixupPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
      ${stdenv.cc.bintools.targetPrefix}install_name_tool \
        -change /usr/lib/libiconv.2.dylib ${libiconv}/lib/libiconv.2.dylib \
        -change /opt/homebrew/lib/libodbcinst.2.dylib ${unixODBC}/lib/libodbcinst.2.dylib \
        $out/${finalAttrs.passthru.driver}
    '';

    postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --set-rpath ${
        lib.makeLibraryPath [
          unixODBC
          openssl
          libkrb5
          libuuid
          stdenv.cc.cc
        ]
      } \
        $out/${finalAttrs.passthru.driver}
    '';

    # see the top of the file for an explanation
    passthru = {
      fancyName = "ODBC Driver ${finalAttrs.versionMajor} for SQL Server";
      driver = "lib/libmsodbcsql${
        if stdenv.hostPlatform.isDarwin then
          ".${finalAttrs.versionMajor}.dylib"
        else
          "-${finalAttrs.versionMajor}.${finalAttrs.versionMinor}.so.${finalAttrs.versionAdditional}"
      }";
    };

    meta = with lib; {
      description = finalAttrs.passthru.fancyName;
      homepage = "https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver16";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      platforms = platforms.unix;
      license = licenses.unfree;
      maintainers = with maintainers; [ SamirTalwar ];
    };
  });

  redshift = stdenv.mkDerivation rec {
    pname = "redshift-odbc";
    version = "1.4.49.1000";

    src = fetchurl {
      url = "https://s3.amazonaws.com/redshift-downloads/drivers/odbc/${version}/AmazonRedshiftODBC-64-bit-${version}-1.x86_64.deb";
      sha256 = "sha256-r5HvsZjB7+x+ClxtWoONkE1/NAbz90NbHfzxC6tf7jA=";
    };

    nativeBuildInputs = [ dpkg ];

    unpackPhase = ''
      dpkg -x $src src
      cd src
    '';

    # `unixODBC` is loaded with `dlopen`, so `autoPatchElfHook` cannot see it, and `patchELF` phase would strip the manual patchelf. Thus:
    # - Manually patchelf with `unixODCB` libraries
    # - Disable automatic `patchELF` phase
    installPhase = ''
      mkdir -p $out/lib
      cp opt/amazon/redshiftodbc/lib/64/* $out/lib
      patchelf --set-rpath ${unixODBC}/lib/ $out/lib/libamazonredshiftodbc64.so
    '';

    dontPatchELF = true;

    buildInputs = [ unixODBC ];

    # see the top of the file for an explanation
    passthru = {
      fancyName = "Amazon Redshift (x64)";
      driver = "lib/libamazonredshiftodbc64.so";
    };

    meta = with lib; {
      broken = stdenv.hostPlatform.isDarwin;
      description = "Amazon Redshift ODBC driver";
      homepage = "https://docs.aws.amazon.com/redshift/latest/mgmt/configure-odbc-connection.html";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [ sir4ur0n ];
    };
  };
}
// lib.optionalAttrs config.allowAliases {
  mysql = throw "unixODBCDrivers.mysql has been removed because it has been marked as broken since 2016."; # Added 2025-10-11
}
