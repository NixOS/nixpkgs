{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "tidgi";
  version = "0.8.0";

  src =
    if stdenv.isAarch64 then
      fetchurl
        {
          url = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/download/v${version}/TidGi-darwin-arm64-${version}.zip";
          hash = "sha256-e3ChSHljZSJiPh6KJ66BgAurBID/HiUQ7Gefq6mpU+c=";
        }
    else
      fetchurl
        {
          url = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/download/v${version}/TidGi-darwin-x64-${version}.zip";
          sha256 = "sha256-w3oNaiaThsjX8kBCUEgBMRVb+R57bH7zABM2K3bdUeU=";
        };

  dontBuild = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "Customizable personal knowledge-base and blogging platform with git as backup manager";
    homepage = "https://github.com/tiddly-gittly/TidGi-Desktop";
    changelog = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ klchen0112 ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
