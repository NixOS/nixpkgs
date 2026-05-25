{
  stdenv,
  lib,
  fetchurl,
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64";
  hashes = {
    "x86_64-linux" = "1i3mhm1swphkimm4dfdiyabxd6w3xni14cnlffz0da1p6a2x11v2";
    "aarch64-linux" = "0p7dxnnxh0nskbdaq5ldf33rqmbgj0ymhqdi89y3pk1yxjlk7bcf";
    "x86_64-darwin" = "0mw5a28nlq0ra69q5fcl2spmvc88qrffzw7ngh5fdmdmvkd9f3wb";
    "aarch64-darwin" = "0j20i5g92h8zx6p3hzxdrh298dkipxxhyvp28asddrxbiscfca1b";
  };
in

stdenv.mkDerivation rec {
  pname = "lamdera";
  version = "1.4.0";

  src = fetchurl {
    url = "https://static.lamdera.com/bin/lamdera-${version}-${os}-${arch}";
    sha256 = hashes.${stdenv.system};
  };

  dontUnpack = true;

  installPhase = ''
    install -m755 -D $src $out/bin/lamdera
  '';

  meta = {
    homepage = "https://lamdera.com";
    license = lib.licenses.bsd3;
    description = "Delightful platform for full-stack web apps";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ Zimmi48 ];
  };
}
