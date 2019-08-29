{ stdenv
, fetchurl
, requireFile
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
  inherit (stdenv.lib) optional optionals optionalString;

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  # assemble list of components
  components = [ "basic" "sdk" "sqlplus" ] ++ optional odbcSupport "odbc";

  # determine the version number, there might be different ones per architecture
  version = {
    "x86_64-linux" = "19.3.0.0.0";
    "x86_64-darwin" = "18.1.0.0.0";
  }."${stdenv.hostPlatform.system}" or throwSystem;

  # hashes per component and architecture
  hashes = {
    "x86_64-linux" = {
      "basic"   = "1yk4ng3a9ka1mzgfph9br6rwclagbgfvmg6kja11nl5dapxdzaxy";
      "sdk"     = "115v1gqr0czy7dcf2idwxhc6ja5b0nind0mf1rn8iawgrw560l99";
      "sqlplus" = "0zj5h84ypv4n4678kfix6jih9yakb277l9hc0819iddc0a5slbi5";
      "odbc"    = "1g1z6pdn76dp440fh49pm8ijfgjazx4cvxdi665fsr62h62xkvch";
    };
    "x86_64-darwin" = {
      "basic"   = "fac3cdaaee7526f6c50ff167edb4ba7ab68efb763de24f65f63fb48cc1ba44c0";
      "sdk"     = "98e6d797f1ce11e59b042b232f62380cec29ec7d5387b88a9e074b741c13e63a";
      "sqlplus" = "02e66dc52398fced75e7efcb6b4372afcf617f7d88344fb7f0f4bb2bed371f3b";
      "odbc"    = "5d0cdd7f9dd2e27affbc9b36ef9fc48e329713ecd36905fdd089366e365ae8a2";
    };
  }."${stdenv.hostPlatform.system}" or throwSystem;

  # rels per component and architecture, optional
  rels = {
    "x86_64-darwin" = {
      "sdk" = "2";
    };
  }."${stdenv.hostPlatform.system}" or {};

  # convert platform to oracle architecture names
  arch = {
    "x86_64-linux" = "linux.x64";
    "x86_64-darwin" = "macos.x64";
  }."${stdenv.hostPlatform.system}" or throwSystem;

  # calculate the filename of a single zip file
  srcFilename = component: arch: version: rel:
    "instantclient-${component}-${arch}-${version}" +
    (optionalString (rel != "") "-${rel}") +
    (optionalString (arch == "linux.x64") "dbru") + # ¯\_(ツ)_/¯
    ".zip";

  # fetcher for the clickthrough artifacts (requiring manual download)
  fetchClickThrough =  srcFilename: hash: (requireFile {
    name = srcFilename;
    url = "https://www.oracle.com/database/technologies/instant-client/downloads.html";
    sha256 = hash;
  });

  # fetcher for the non clickthrough artifacts
  fetchSimple = srcFilename: hash: fetchurl {
    url = "https://download.oracle.com/otn_software/linux/instantclient/193000/${srcFilename}";
    sha256 = hash;
  };

  # pick the appropriate fetcher depending on the platform
  fetcher = if stdenv.hostPlatform.system == "x86_64-linux" then fetchSimple else fetchClickThrough;

  # assemble srcs
  srcs = map (component:
    (fetcher (srcFilename component arch version rels."${component}" or "") hashes."${component}" or ""))
  components;

  pname = "oracle-instantclient";
  extLib = stdenv.hostPlatform.extensions.sharedLibrary;
in stdenv.mkDerivation {
  inherit pname version srcs;

  buildInputs = [ stdenv.cc.cc.lib ]
    ++ optional stdenv.isLinux libaio
    ++ optional odbcSupport unixODBC;

  nativeBuildInputs = [ makeWrapper unzip ]
    ++ optional stdenv.isLinux autoPatchelfHook
    ++ optional stdenv.isDarwin fixDarwinDylibNames;

  outputs = [ "out" "dev" "lib"];

  unpackCmd = "unzip $curSrc";

  installPhase = ''
    mkdir -p "$out/"{bin,include,lib,"share/java","share/${pname}-${version}/demo/"} $lib/lib
    install -Dm755 {adrci,genezi,uidrvci,sqlplus} $out/bin

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
