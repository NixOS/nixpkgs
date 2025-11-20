{
  stdenv,
  lib,
  fetchurl,
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
stdenv.mkDerivation rec {
  pname = "urbit";
  version = "4.0";

  src = fetchurl {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 =
      {
        x86_64-linux = "043cpvvfg48r5vza2y18890crpk030l59sa4v3jj737cmgwzyric";
        aarch64-linux = "1j5xsywqkms85k1p390hr2hc4zcq3bx3sxi4j0s1s6d6bqxwpikn";
        x86_64-darwin = "0s403s66fxhihyhvriacl654a07zsi69sh5w7m23gn87mrz3hx8x";
        aarch64-darwin = "0aczb9zxq03a69a39q6rvnhmchrj5x025ia1jzqzdw1rhb4m4yxr";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  unpackPhase = ''
    mkdir src
    tar -C src -xf $src
  '';

  postInstall = ''
    install -m755 -D src/vere-v${version}-${platform} $out/bin/urbit
  '';

  passthru.updateScript = ./update-bin.sh;

  meta = with lib; {
    homepage = "https://urbit.org";
    description = "Operating function";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ maintainers.matthew-levan ];
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "urbit";
  };
}
