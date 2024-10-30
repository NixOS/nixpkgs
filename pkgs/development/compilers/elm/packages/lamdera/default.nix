{ stdenv
, lib
, fetchurl
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64";
  hashes =
    {
      "x86_64-linux" = "8534ff055073490719ed05be847bebef46250ebb7af1d72bdaa4fc115c6dcea3";
      "aarch64-linux" = "01397ce50cb0ad1dac18e4e0f7ab490bbf41a1c23d06a1946eec689e7811085b";
      "x86_64-darwin" = "46305fb0de9fd7685fdf7cf175ad965d5320f76d4b5f2de2f9dc8403c8127d52";
      "aarch64-darwin" = "b1e3d7bd624cdff0522bd71dc5825fa98b4eed1eae064df55a86a40b554ce0d1";
    };
in

stdenv.mkDerivation rec {
  pname = "lamdera";
  version = "1.3.1";

  src = fetchurl {
    url = "https://static.lamdera.com/bin/lamdera-${version}-${os}-${arch}";
    sha256 = hashes.${stdenv.system};
  };

  dontUnpack = true;

  installPhase = ''
    install -m755 -D $src $out/bin/lamdera
  '';

  meta = with lib; {
    homepage = "https://lamdera.com";
    license = licenses.unfree;
    description = "Delightful platform for full-stack web apps";
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
