{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, fixDarwinDylibNames
, unzip
, libaio
, makeWrapper
, odbcSupport ? true
, unixODBC
}:

assert odbcSupport -> unixODBC != null;

let
  inherit (lib) optional optionals optionalString;

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  # assemble list of components
  components = [ "basic" "sdk" "sqlplus" "tools" ] ++ optional odbcSupport "odbc";

  # determine the version number, there might be different ones per architecture
  version = {
    x86_64-linux = "19.16.0.0.0";
    aarch64-linux = "19.10.0.0.0";
    x86_64-darwin = "19.3.0.0.0";
  }.${stdenv.hostPlatform.system} or throwSystem;

  directory = {
    x86_64-linux = "1916000";
    aarch64-linux = "191000";
    x86_64-darwin = "193000";
  }.${stdenv.hostPlatform.system} or throwSystem;

  # hashes per component and architecture
  hashes = {
    x86_64-linux = {
      basic = "sha256-Sq1rWvbC1YME7EjSYPaP2g+1Xxxkk4ZkGaBmLo2cKcQ=";
      sdk = "sha256-yJ8f/Hlq6vZoPxv+dfY4z1E7rWvcqlK+ou0SU0KKlEI=";
      sqlplus = "sha256-C44srukpCB9et9UWm59daJmU83zr0HAktnWv7R42Irw=";
      tools = "sha256-GP4E1REIoU3lctVYmLsAiwTJEvGRpCmOFlRuZk+A8HE=";
      odbc = "sha256-JECxK7Ia1IJtve2goZJdTkvm5NJjqB2rc6k5BXUt3oA=";
    };
    aarch64-linux = {
      basic = "sha256-DNntH20BAmo5kOz7uEgW2NXaNfwdvJ8l8oMnp50BOsY=";
      sdk = "sha256-8VpkNyLyFMUfQwbZpSDV/CB95RoXfaMr8w58cRt/syw=";
      sqlplus = "sha256-iHcyijHhAvjsAqN9R+Rxo2R47k940VvPbScc2MWYn0Q=";
      tools = "sha256-4QY0EwcnctwPm6ZGDZLudOFM4UycLFmRIluKGXVwR0M=";
      odbc = "sha256-T+RIIKzZ9xEg/E72pfs5xqHz2WuIWKx/oRfDrQbw3ms=";
    };
    x86_64-darwin = {
      basic = "f4335c1d53e8188a3a8cdfb97494ff87c4d0f481309284cf086dc64080a60abd";
      sdk = "b46b4b87af593f7cfe447cfb903d1ae5073cec34049143ad8cdc9f3e78b23b27";
      sqlplus = "f7565c3cbf898b0a7953fbb0017c5edd9d11d1863781588b7caf3a69937a2e9e";
      tools = "b2bc474f98da13efdbc77fd05f559498cd8c08582c5b9038f6a862215de33f2c";
      odbc = "f91da40684abaa866aa059eb26b1322f2d527670a1937d678404c991eadeb725";
    };
  }.${stdenv.hostPlatform.system} or throwSystem;

  # rels per component and architecture, optional
  rels = { }.${stdenv.hostPlatform.system} or { };

  # convert platform to oracle architecture names
  arch = {
    x86_64-linux = "linux.x64";
    aarch64-linux = "linux.arm64";
    x86_64-darwin = "macos.x64";
  }.${stdenv.hostPlatform.system} or throwSystem;

  shortArch = {
    x86_64-linux = "linux";
    aarch64-linux = "linux";
    x86_64-darwin = "mac";
  }.${stdenv.hostPlatform.system} or throwSystem;

  # calculate the filename of a single zip file
  srcFilename = component: arch: version: rel:
    "instantclient-${component}-${arch}-${version}" +
    (optionalString (rel != "") "-${rel}") +
    "dbru.zip"; # ¯\_(ツ)_/¯

  # fetcher for the non clickthrough artifacts
  fetcher = srcFilename: hash: fetchurl {
    url = "https://download.oracle.com/otn_software/${shortArch}/instantclient/${directory}/${srcFilename}";
    sha256 = hash;
  };

  # assemble srcs
  srcs = map
    (component:
      (fetcher (srcFilename component arch version rels.${component} or "") hashes.${component} or ""))
    components;

  pname = "oracle-instantclient";
  extLib = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation {
  inherit pname version srcs;

  buildInputs = [ stdenv.cc.cc.lib ]
    ++ optional stdenv.isLinux libaio
    ++ optional odbcSupport unixODBC;

  nativeBuildInputs = [ makeWrapper unzip ]
    ++ optional stdenv.isLinux autoPatchelfHook
    ++ optional stdenv.isDarwin fixDarwinDylibNames;

  outputs = [ "out" "dev" "lib" ];

  unpackCmd = "unzip $curSrc";

  installPhase = ''
    mkdir -p "$out/"{bin,include,lib,"share/java","share/${pname}-${version}/demo/"} $lib/lib
    install -Dm755 {adrci,genezi,uidrvci,sqlplus,exp,expdp,imp,impdp} $out/bin

    # cp to preserve symlinks
    cp -P *${extLib}* $lib/lib

    install -Dm644 *.jar $out/share/java
    install -Dm644 sdk/include/* $out/include
    install -Dm644 sdk/demo/* $out/share/${pname}-${version}/demo

    # provide alias
    ln -sfn $out/bin/sqlplus $out/bin/sqlplus64
  '';

  postFixup = optionalString stdenv.isDarwin ''
    for exe in "$out/bin/"* ; do
      if [ ! -L "$exe" ]; then
        install_name_tool -add_rpath "$lib/lib" "$exe"
      fi
    done
  '';

  meta = with lib; {
    description = "Oracle instant client libraries and sqlplus CLI";
    longDescription = ''
      Oracle instant client provides access to Oracle databases (OCI,
      OCCI, Pro*C, ODBC or JDBC). This package includes the sqlplus
      command line SQL client.
    '';
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ flokli ];
    hydraPlatforms = [ ];
  };
}
