{ stdenv, requireFile, libelf, gcc, glibc, patchelf, unzip, rpmextract, libaio
, odbcSupport ? false, unixODBC
}:

assert odbcSupport -> unixODBC != null;

let optional = stdenv.lib.optional;
    optionalString  = stdenv.lib.optionalString;
    requireSource = version: part: hash: (requireFile rec {
      name = "oracle-instantclient12.1-${part}-${version}.x86_64.rpm";
      message = ''
        This Nix expression requires that ${name} already
        be part of the store. Download the file
        manually at

        http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

        and add it to the Nix store using either:
          nix-store --add-fixed sha256 ${name}
        or
          nix-prefetch-url --type sha256 file:///path/to/${name}
      '';
      url = "http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html";
      sha256 = hash;
    });
in stdenv.mkDerivation rec {
  version = "12.1.0.2.0-1";
  name = "oracle-instantclient-${version}";

  srcBase = (requireSource version "basic" "f0e51e247cc3f210b950fd939ab1f696de9ca678d1eb179ba49ac73acb9a20ed");
  srcDevel = (requireSource version "devel" "13b638882f07d6cfc06c85dc6b9eb5cac37064d3d594194b6b09d33483a08296");
  srcSqlplus = (requireSource version "sqlplus" "16d87w1lii0ag47c8srnr7v4wfm9q4hy6gka8m3v6gp9cc065vam");
  srcOdbc = optionalString odbcSupport (requireSource version "odbc" "d3aa1a4957a2f15ced05921dab551ba823aa7925d8fcb58d5b3a7f624e4df063");

  buildInputs = [ glibc patchelf rpmextract ] ++
    optional odbcSupport unixODBC;

  buildCommand = ''
    mkdir -p "${name}"
    cd "${name}"
    ${rpmextract}/bin/rpmextract "${srcBase}"
    ${rpmextract}/bin/rpmextract "${srcDevel}"
    ${rpmextract}/bin/rpmextract "${srcSqlplus}"
    ${optionalString odbcSupport ''
        ${rpmextract}/bin/rpmextract "${srcOdbc}"
    ''}

    mkdir -p "$out/"{bin,include,lib,"share/${name}/demo/"}
    mv "usr/share/oracle/12.1/client64/demo/"* "$out/share/${name}/demo/"
    mv "usr/include/oracle/12.1/client64/"* "$out/include/"
    mv "usr/lib/oracle/12.1/client64/lib/"* "$out/lib/"
    mv "usr/lib/oracle/12.1/client64/bin/"* "$out/bin/"
    ln -s "$out/bin/sqlplus" "$out/bin/sqlplus64"

    for lib in $out/lib/lib*.so; do
      test -f $lib || continue
      chmod +x $lib
      patchelf --force-rpath --set-rpath "$out/lib:${libaio}/lib" \
               $lib
    done

    for lib in $out/lib/libsqora*; do
      test -f $lib || continue
      chmod +x $lib
      patchelf --force-rpath --set-rpath "$out/lib:${unixODBC}/lib" \
               $lib
    done

    for exe in $out/bin/sqlplus; do
      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
               --force-rpath --set-rpath "$out/lib:${libaio}/lib" \
               $exe
    done
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "Oracle instant client libraries and sqlplus CLI";
    longDescription = ''
      Oracle instant client provides access to Oracle databases (OCI,
      OCCI, Pro*C, ODBC or JDBC). This package includes the sqlplus
      command line SQL client.
    '';
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pesterhazy ];
  };
}
