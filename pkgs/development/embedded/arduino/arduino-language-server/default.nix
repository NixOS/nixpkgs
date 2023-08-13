{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "arduino-language-server";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "arduino-language-server";
    rev = "refs/tags/${version}";
    hash = "sha256-A5JcHdcSrRC1BxoJsPtLKBq1fu58SvwHm9hbgu8Uy5k=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-SKqorfgesYE0kXR/Fm6gI7Me0CxtDeNsTRGYuGJW+vo=";

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
