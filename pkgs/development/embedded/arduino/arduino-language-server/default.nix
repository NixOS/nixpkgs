{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "arduino-language-server";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "arduino-language-server";
    rev = version;
    hash = "sha256-FnkXtjktj22LCkmFPxzQ72qiVBC1WR/ZiwMsmZPL578=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-Xa26ilo95sQ/6dGvl4gB2bb0vzWXr+WPKLezAnZPeqM=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/arduino/arduino-language-server/version.versionString=${version}"
    "-X github.com/arduino/arduino-language-server/version.commit=unknown"
  ] ++ lib.optionals stdenv.isLinux [ "-extldflags '-static'" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "An Arduino Language Server based on Clangd to Arduino code autocompletion";
    license = licenses.asl20;
    maintainers = with maintainers; [ BattleCh1cken ];
  };
}
