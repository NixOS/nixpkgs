{
  fetchurl,
  lib,
  stdenv,
}:
let
  currentSystem = stdenv.hostPlatform.system;
  specs = {
    x86_64-darwin = {
      url = "https://download.microsoft.com/download/1/9/A/19AF548A-6DD3-4B48-88DC-724E9ABCEB9A/msodbcsql17-17.9.1.1-amd64.tar.gz";
      sha256 = "14qdcgl40h8ah6qhwzpbddpcy9f3jsl4m5pd0y3frgkz31ddgab2";
    };
    aarch64-darwin = {
      url = "https://download.microsoft.com/download/1/9/A/19AF548A-6DD3-4B48-88DC-724E9ABCEB9A/msodbcsql17-17.9.1.1-arm64.tar.gz";
      sha256 = "1bmyyv25zrvhszm7fd37w5ys9aqgmvlb12vngnp3cq16xyz3z4x7";
    };
  };
  spec = specs.${currentSystem} or (throw "Unsupported darwin platform");
in stdenv.mkDerivation {
  pname = "msodbc17";
  version = "17.9.1.1";
  src = fetchurl spec;
  installPhase = ''
    mkdir $out
    cp -r . $out
    rm $out/odbcinst.ini
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
