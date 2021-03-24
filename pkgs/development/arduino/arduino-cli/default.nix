{ lib, stdenv, buildGoModule, fetchFromGitHub, buildFHSUserEnv }:

let

  pkg = buildGoModule rec {
    pname = "arduino-cli";
    version = "0.17.0";

    src = fetchFromGitHub {
      owner = "arduino";
      repo = pname;
      rev = version;
      sha256 = "7p86mhBg0U8cBZR1P43eBWS9fbMBJ9l5ga0IOedNzm4=";
    };

    subPackages = [ "." ];

    vendorSha256 = "kPIhG6lsH+0IrYfdlzdv/X/cUQb22Xza9Q6ywjKae/4=";

    buildFlagsArray = [
      "-ldflags=-s -w -X github.com/arduino/arduino-cli/version.versionString=${version} -X github.com/arduino/arduino-cli/version.commit=unknown"
    ] ++ lib.optionals stdenv.isLinux [ "-extldflags '-static'" ];

    meta = with lib; {
      inherit (src.meta) homepage;
      description = "Arduino from the command line";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ ryantm ];
    };

  };

# buildFHSUserEnv is needed because the arduino-cli downloads compiler
# toolchains from the internet that have their interpreters pointed at
# /lib64/ld-linux-x86-64.so.2
in buildFHSUserEnv {
  inherit (pkg) name meta;

  runScript = "${pkg.outPath}/bin/arduino-cli";

  extraInstallCommands = ''
    mv $out/bin/$name $out/bin/arduino-cli
  '';
}
