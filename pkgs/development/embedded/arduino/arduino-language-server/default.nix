{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "arduino-language-server";
<<<<<<< HEAD
  version = "0.7.5";
=======
  version = "0.7.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "arduino-language-server";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-RBoDT/KnbQHeuE5WpoL4QWu3gojiNdsi+/NEY2e/sHs=";
=======
    hash = "sha256-A5JcHdcSrRC1BxoJsPtLKBq1fu58SvwHm9hbgu8Uy5k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = [ "." ];

<<<<<<< HEAD
  vendorHash = "sha256-tS6OmH757VDdViPHJAJAftQu+Y1YozE7gXkt5anDlT0=";
=======
  vendorHash = "sha256-SKqorfgesYE0kXR/Fm6gI7Me0CxtDeNsTRGYuGJW+vo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/arduino/arduino-language-server/version.versionString=${version}"
    "-X github.com/arduino/arduino-language-server/version.commit=unknown"
  ] ++ lib.optionals stdenv.isLinux [
    "-extldflags '-static'"
  ];

  meta = with lib; {
    description = "An Arduino Language Server based on Clangd to Arduino code autocompletion";
    homepage = "https://github.com/arduino/arduino-language-server";
    changelog = "https://github.com/arduino/arduino-language-server/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ BattleCh1cken ];
  };
}
