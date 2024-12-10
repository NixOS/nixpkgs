{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "arduino-language-server";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "arduino-language-server";
    rev = "refs/tags/${version}";
    hash = "sha256-PmPGhbB1HqxZRK+f28SdZNh4HhE0oseYsdJuEAAk90I=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-tS6OmH757VDdViPHJAJAftQu+Y1YozE7gXkt5anDlT0=";

  doCheck = false;

  ldflags =
    [
      "-s"
      "-w"
      "-X github.com/arduino/arduino-language-server/version.versionString=${version}"
      "-X github.com/arduino/arduino-language-server/version.commit=unknown"
    ]
    ++ lib.optionals stdenv.isLinux [
      "-extldflags '-static'"
    ];

  meta = with lib; {
    description = "An Arduino Language Server based on Clangd to Arduino code autocompletion";
    mainProgram = "arduino-language-server";
    homepage = "https://github.com/arduino/arduino-language-server";
    changelog = "https://github.com/arduino/arduino-language-server/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ BattleCh1cken ];
  };
}
