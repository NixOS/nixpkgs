{
  darwin,
  fetchurl,
  gnused,
  lib,
  libcxx,
  patchDylib,
  stdenv,
  unixODBC,
}:
let
  currentSystem = stdenv.hostPlatform.system;
  specs = {
    x86_64-darwin = {
      url = "https://download.microsoft.com/download/1/9/A/19AF548A-6DD3-4B48-88DC-724E9ABCEB9A/msodbcsql17-17.10.4.1-amd64.tar.gz";
      sha256 = "ca5f1898e8e16ab2627b80380fd81ab33858f2f94a72ccdbe11e111547de8b82";
    };
    aarch64-darwin = {
      url = "https://download.microsoft.com/download/1/9/A/19AF548A-6DD3-4B48-88DC-724E9ABCEB9A/msodbcsql17-17.10.4.1-arm64.tar.gz";
      sha256 = "0922c5cbeecde780193d35c60957af66f79046d1fb2355c7a96ef081ae985f64";
    };
  };
  spec = specs.${currentSystem} or (throw "Unsupported darwin platform");
in stdenv.mkDerivation {
  pname = "msodbc17";
  version = "17.10.4.1";
  src = fetchurl spec;
  nativeBuildInputs = [ gnused patchDylib];
  dontBuild = true;
  installPhase = ''
    mkdir $out
    cp -r . $out

    # Setup odbcinst.ini for the driver to be found by unixODBC
    # The file will have to be copied into a folder
    #  and pointed to, which is possible with the env var ODBCSYSINI
    # We can't put it into /etc/ as it would override other drivers
    sed -i -e "s|Driver=.*|Driver=$(ls -1 $out/lib/*.dylib)|" \
        $out/odbcinst.ini
  '';
  fixupPhase = ''
    runHook preFixup

    patchDylib "$(ls -1 $out/lib/*.dylib)" "${lib.strings.makeLibraryPath [
        darwin.libiconv
        libcxx
        unixODBC
      ]}"

    runHook postFixup
  '';

  meta = with lib;{
    description = "ODBC Driver for Microsoft(R) SQL Server(R) 17";
    hydraPlatforms = [];
    license = licenses.unfree;
    maintainers = with maintainers; [
      michaelCTS
    ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
