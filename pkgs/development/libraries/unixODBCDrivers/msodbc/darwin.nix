{
  darwin,
  fetchurl,
  lib,
  libcxx,
  patchDylib,
  ripgrep,
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
  buildInputs = [ unixODBC ];
  nativeBuildInputs = [ patchDylib ];
  installPhase = ''
    mkdir $out
    cp -r . $out
    # TODO: Move it to /etc
    rm $out/odbcinst.ini
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
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    license = licenses.unfree;
  };
}
