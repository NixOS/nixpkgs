{ stdenv
, lib
, fetchurl
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64";
  hashes =
    {
      "x86_64-linux" = "a51d5b9a011c54b0001ff3273cee027774686e233adadb20b1978d2cabfe32a6";
      "aarch64-linux" = "8904ce928f60e06df1f06b3af5ee5eb320c388922aa38b698d823df1d73e8e49";
      "x86_64-darwin" = "b4d1bb5ddc3503862750e5b241f74c22dc013792bc4f410dd914a5216e20ed2f";
      "aarch64-darwin" = "6d20e384dae90bb994c3f1e866c964124c7e8a51e9e08bad0e90a2b560bb5a18";
    };
in

stdenv.mkDerivation rec {
  pname = "lamdera";
  version = "1.2.1";

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
