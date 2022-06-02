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
    x86_64-linux = "19.3.0.0.0";
    x86_64-darwin = "19.3.0.0.0";
  }.${stdenv.hostPlatform.system} or throwSystem;

  # hashes per component and architecture
  hashes = {
    x86_64-linux = {
      basic = "1yk4ng3a9ka1mzgfph9br6rwclagbgfvmg6kja11nl5dapxdzaxy";
      sdk = "115v1gqr0czy7dcf2idwxhc6ja5b0nind0mf1rn8iawgrw560l99";
      sqlplus = "0zj5h84ypv4n4678kfix6jih9yakb277l9hc0819iddc0a5slbi5";
      tools = "1q19blr0gz1c8bq0bnv1njzflrp03hf82ngid966xc6gwmqpkdsk";
      odbc = "1g1z6pdn76dp440fh49pm8ijfgjazx4cvxdi665fsr62h62xkvch";
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
    x86_64-darwin = "macos.x64";
  }.${stdenv.hostPlatform.system} or throwSystem;

  shortArch = {
    x86_64-linux = "linux";
    x86_64-darwin = "mac";
  }.${stdenv.hostPlatform.system} or throwSystem;

  # calculate the filename of a single zip file
  srcFilename = component: arch: version: rel:
    "instantclient-${component}-${arch}-${version}" +
    (optionalString (rel != "") "-${rel}") +
    (optionalString (arch == "linux.x64" || arch == "macos.x64") "dbru") + # ¯\_(ツ)_/¯
    ".zip";

  # fetcher for the non clickthrough artifacts
  fetcher = srcFilename: hash: fetchurl {
    url = "https://download.oracle.com/otn_software/${shortArch}/instantclient/193000/${srcFilename}";
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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ flokli ];
    hydraPlatforms = [ ];
  };
}
