{ stdenv, fetchurl, dpkg, runCommand, binutils
, utillinux, glibc, curl, unixODBC-MSSQL, libkrb5, openssl
, odbcDriverManager, odbcDriverManagerDrv ? unixODBC-MSSQL
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "msodbcsql-${version}";
  version = "13.0.1.0";

  src = fetchurl {
    # this link might change on new ubuntu releases, sorry. :(
    url = "https://apt-mo.trafficmanager.net/repos/mssql-ubuntu-xenial-release/pool/main/m/msodbcsql/msodbcsql_${version}-1_amd64.deb";
    sha256 = "0pvp8ckwz0wzdf2c90ii4ccmgw0imf5nh16b6vi5brcnq3nf3y3h";
  };

  dontBuild = true;

  unpackCmd = "${getBin dpkg}/bin/dpkg-deb --extract $curSrc ./pkg";

  patchPhase = ''
    sed -e '/Driver=/ s|.*|Driver=lib/libmsodbcsql.so/|' \
        -i opt/microsoft/msodbcsql/etc/odbcinst.ini
  '';

  installPhase = ''
    mkdir -p $out/lib
    mv opt/microsoft/msodbcsql/{etc,share,include} $out
    # only first two parts of version, like 13.0
    VER=$(echo ${version} | cut -d'.' -f1,2)
    mv "opt/microsoft/msodbcsql/lib64/libmsodbcsql-$VER.so.1.0" \
          $out/lib/libmsodbcsql.so
    mv usr/share/doc $out/share/doc
  '';

  postFixup = ''
    patchelf --set-rpath "${makeLibraryPath
      ([ stdenv.cc.cc.lib utillinux glibc curl libkrb5 openssl ]
      ++ (if odbcDriverManager == "unixODBC-MSSQL" then [ odbcDriverManagerDrv ]
          else warn "Only unixODBC-MSSQL is supported by msodbcsql, proceed at your own peril"
            [ odbcDriverManagerDrv ]))}" \
      $out/lib/libmsodbcsql.so

    # Okay, this is pretty crazy. there is one path that links to /opt.
    # We can’t have that. So we overwrite the path in the binary.
    # There’s another string afterwards, but we just hope or the best.
    OBJ="$out/lib/libmsodbcsql.so"
    # we write a file with the needed path in it, ending with \0
    echo -ne "$out/share/resources/en_US/\0" > path
    # we find out the offset address with strings
    OFFSET=$(${getBin binutils}/bin/strings -td "$OBJ" \
      | grep /opt/microsoft/msodbcsql/share/resources/en_US/ \
      | cut -d' ' -f1)
    echo OFFSET $OFFSET
    # let’s overwrite the path
    dd if=path of="$OBJ" bs=$OFFSET seek=1 conv=notrunc
    ls -la $OBJ
    # done
  '';

  passthru = {
    # for use with ODBC driver managers
    fancyName = "Microsoft ODBC Driver 13 for SQL Server";
    driver = "lib/libmsodbcsql.so";
  };

  meta = {
    description = "ODBC access to SQL Server, Azure SQL Database and Azure SQL DW";
    license = licenses.unfree;
    homepage = "https://www.microsoft.com/en-us/download/details.aspx?id=28160";
    maintainer = [ maintainers.profpatsch ];
  };
}
