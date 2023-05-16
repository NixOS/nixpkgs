{ stdenv, lib
, fetchurl
}:

let
  os = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x86_64";
  hashes =
    {
<<<<<<< HEAD
      "x86_64-linux" = "b13110bacc3f71c2a3e12c52172a821a85cc13243a95249ca18c8beb296c0ce8";
      "aarch64-linux" = "afbc71f0570b86215942d1b4207fe3de0299e6fdfd2e6caac78bf688c81b9bd1";
      "x86_64-darwin" = "50a3df09b02b34e1653beb1507c6de0f332674e088ded7c66af4e5987753304e";
      "aarch64-darwin" = "174a5bfec355361c4f030861405513818be25fd7e4325f7221aa71ebd27475d3";
=======
      "x86_64-linux" = "443a763487366fa960120bfe193441e6bbe86fdb31baeed7dbb17d410dee0522";
      "aarch64-linux" = "f11bec3b094df0c0958a8f1e07af5570199e671a882ad5fe979f1e7e482e986d";
      "x86_64-darwin" = "d05a88d13e240fdbc1bf64bd1a4a9ec4d3d53c95961bb9e338449b856df91853";
      "aarch64-darwin" = "bb105e7aebae3c637b761017c6fb49d9696eba1022f27ec594aac9c2dbffd907";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
in

stdenv.mkDerivation rec {
  pname = "lamdera";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    description = "A delightful platform for full-stack web apps";
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ Zimmi48 ];
  };
}
