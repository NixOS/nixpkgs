{ stdenv
, lib
, fetchurl
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64";
  hashes =
    {
      "x86_64-linux" = "1v596zi4zmx88r4axrp7pmci3w9c6f1kz4izrbj65c7ch6wwa7f2";
      "aarch64-linux" = "0xf6lqm9xgph8q95h6smq6dzn5549nfsnayny5nyvm56nbmv5iw9";
      "x86_64-darwin" = "0kijrjfbr7hn469x67yya6ndfwj901m54gd96sq3yiay0jvmapga";
      "aarch64-darwin" = "1iigsd4ac0cbb1q2g02zxjxpcma6yyd7ms72ri8g2vq8i90zys9n";
    };
in

stdenv.mkDerivation rec {
  pname = "lamdera";
  version = "1.3.0";

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
