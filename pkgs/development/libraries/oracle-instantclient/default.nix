{ stdenv, requireFile, autoPatchelfHook, rpmextract, libaio, makeWrapper, odbcSupport ? false, unixODBC }:

assert odbcSupport -> unixODBC != null;

let
    baseVersion = "12.2";
    requireSource = version: rel: part: hash: (requireFile rec {
      name = "oracle-instantclient${baseVersion}-${part}-${version}-${rel}.x86_64.rpm";
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
  version = "${baseVersion}.0.1.0";
  name = "oracle-instantclient-${version}";

  buildInputs = [ libaio stdenv.cc.cc.lib ] ++ stdenv.lib.optional odbcSupport unixODBC;
  nativeBuildInputs = [ autoPatchelfHook makeWrapper rpmextract ];

  srcs = [
    (requireSource version "1" "basic" "43c4bfa938af741ae0f9964a656f36a0700849f5780a2887c8e9f1be14fe8b66")
    (requireSource version "1" "devel" "4c7ad8d977f9f908e47c5e71ce56c2a40c7dc83cec8a5c106b9ff06d45bb3442")
    (requireSource version "1" "sqlplus" "303e82820a10f78e401e2b07d4eebf98b25029454d79f06c46e5f9a302ce5552")
  ] ++ stdenv.lib.optional odbcSupport (requireSource version "2" "odbc" "e870c84d2d4be6f77c0760083b82b7ffbb15a4bf5c93c4e6c84f36d6ed4dfdf1");

  unpackCmd = "rpmextract $curSrc";

  installPhase = ''
    mkdir -p "$out/"{bin,include,lib,"share/${name}/demo/"}

    install -Dm755 lib/oracle/${baseVersion}/client64/bin/* $out/bin
    ln -s $out/bin/sqlplus $out/bin/sqlplus64
    install -Dm644 lib/oracle/${baseVersion}/client64/lib/* $out/lib
    install -Dm644 include/oracle/${baseVersion}/client64/* $out/include
    install -Dm644 share/oracle/${baseVersion}/client64/demo/* $out/share/${name}/demo
  '';

  meta = with stdenv.lib; {
    description = "Oracle instant client libraries and sqlplus CLI";
    longDescription = ''
      Oracle instant client provides access to Oracle databases (OCI,
      OCCI, Pro*C, ODBC or JDBC). This package includes the sqlplus
      command line SQL client.
    '';
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ pesterhazy flokli ];
    hydraPlatforms = [];
  };
}
