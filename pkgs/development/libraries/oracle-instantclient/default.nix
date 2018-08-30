{ stdenv, requireFile, autoPatchelfHook, fixDarwinDylibNames, unzip, libaio, makeWrapper, odbcSupport ? false, unixODBC }:

assert odbcSupport -> unixODBC != null;

let
  inherit (stdenv.lib) optional optionals optionalString;

  baseVersion = "12.2";
  version = "${baseVersion}.0.1.0";

  requireSource = component: arch: version: rel: hash: (requireFile rec {
    name = "instantclient-${component}-${arch}-${version}" + (optionalString (rel != "") "-${rel}") + ".zip";
    url = "http://www.oracle.com/technetwork/database/database-technologies/instant-client/downloads/index.html";
    sha256 = hash;
  });

  throwSystem = throw "Unsupported system: ${stdenv.system}";

  arch = {
    "x86_64-linux" = "linux.x64";
    "x86_64-darwin" = "macos.x64";
  }."${stdenv.system}" or throwSystem;

  srcs = {
    "x86_64-linux" = [
      (requireSource "basic" arch version "" "5015e3c9fba84e009f7519893f798a1622c37d1ae2c55104ff502c52a0fe5194")
      (requireSource "sdk" arch version "" "7f404c3573c062ce487a51ac4cfe650c878d7edf8e73b364ec852645ed1098cb")
      (requireSource "sqlplus" arch version "" "d49b2bd97376591ca07e7a836278933c3f251875c215044feac73ba9f451dfc2") ]
      ++ optional odbcSupport (requireSource "odbc" arch version "2" "365a4ae32c7062d9fbc3fb41add748e7881f774484a175a4b41a2c294ce9095d");
    "x86_64-darwin" = [
      (requireSource "basic" arch version "2" "3ed3102e5a24f0da638694191edb34933309fb472eb1df21ad5c86eedac3ebb9")
      (requireSource "sdk" arch version "2" "e0befca9c4e71ebc9f444957ffa70f01aeeec5976ea27c40406471b04c34848b")
      (requireSource "sqlplus" arch version "2" "d147cbb5b2a954fdcb4b642df4f0bd1153fd56e0f56e7fa301601b4f7e2abe0e") ]
      ++ optional odbcSupport (requireSource "odbc" arch version "2" "1805c1ab6c8c5e8df7bdcc35d7f2b94c329ecf4dff9bde55d5f9b159ecd8b64e");
  }."${stdenv.system}" or throwSystem;

  extLib = stdenv.hostPlatform.extensions.sharedLibrary;
in stdenv.mkDerivation rec {
  inherit version srcs;
  name = "oracle-instantclient-${version}";

  buildInputs = [ stdenv.cc.cc.lib ]
    ++ optionals (stdenv.isLinux) [ libaio ]
    ++ optional odbcSupport unixODBC;

  nativeBuildInputs = [ makeWrapper unzip ]
    ++ optional stdenv.isLinux autoPatchelfHook
    ++ optional stdenv.isDarwin fixDarwinDylibNames;

  unpackCmd = "unzip $curSrc";

  installPhase = ''
    mkdir -p "$out/"{bin,include,lib,"share/java","share/${name}/demo/"}
    install -Dm755 {sqlplus,adrci,genezi} $out/bin
    ${optionalString stdenv.isDarwin ''
      for exe in "$out/bin/"* ; do
        install_name_tool -add_rpath "$out/lib" "$exe"
      done
    ''}
    ln -sfn $out/bin/sqlplus $out/bin/sqlplus64
    install -Dm644 *${extLib}* $out/lib
    install -Dm644 *.jar $out/share/java
    install -Dm644 sdk/include/* $out/include
    install -Dm644 sdk/demo/* $out/share/${name}/demo

    # PECL::oci8 will not build without this
    # this symlink only exists in dist zipfiles for some platforms
    ln -sfn $out/lib/libclntsh${extLib}.12.1 $out/lib/libclntsh${extLib}
  '';

  meta = with stdenv.lib; {
    description = "Oracle instant client libraries and sqlplus CLI";
    longDescription = ''
      Oracle instant client provides access to Oracle databases (OCI,
      OCCI, Pro*C, ODBC or JDBC). This package includes the sqlplus
      command line SQL client.
    '';
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ pesterhazy flokli ];
    hydraPlatforms = [];
  };
}
