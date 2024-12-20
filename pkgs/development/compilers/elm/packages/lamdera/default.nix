{
  stdenv,
  lib,
  fetchurl,
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64";
  hashes = {
    "x86_64-linux" = "15a69bfa98155651749e31c68d05a04fcf48bdccb86bce77b7c8872f545cecfa";
    "aarch64-linux" = "68a16bbbd2ed0ee19c36112a4c2d0abca66cf17465747e55adf2596b0921f8d7";
    "x86_64-darwin" = "af2c63a60a689091a01bfd212e0ce141a6d7ba61d34a585d8f83159d0ed39c6f";
    "aarch64-darwin" = "06f9f7fdcbb392a0a8a5034baf915d2b95b2876255aa8df8397ddafd1e540b7a";
  };
in

stdenv.mkDerivation rec {
  pname = "lamdera";
  version = "1.3.2";

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
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
