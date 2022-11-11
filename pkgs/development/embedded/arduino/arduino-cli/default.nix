{ lib, stdenv, buildGoModule, fetchFromGitHub, buildFHSUserEnv }:

let

  pkg = buildGoModule rec {
    pname = "arduino-cli";
    version = "0.28.0";

    src = fetchFromGitHub {
      owner = "arduino";
      repo = pname;
      rev = version;
      sha256 = "sha256-i6osx4j1YVAYaVVdEQ4ImfaIvXw5jPYmgpEYz6XGkY8=";
    };

    subPackages = [ "." ];

    vendorSha256 = "sha256-NIqsYAnW9elprKWjqmNIsF452thuWT1i8YNPUuuwjVs=";

    doCheck = false;

    ldflags = [
      "-s" "-w" "-X github.com/arduino/arduino-cli/version.versionString=${version}" "-X github.com/arduino/arduino-cli/version.commit=unknown"
    ] ++ lib.optionals stdenv.isLinux [ "-extldflags '-static'" ];

    meta = with lib; {
      inherit (src.meta) homepage;
      description = "Arduino from the command line";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ ryantm ];
    };

  };

in
if stdenv.isLinux then
# buildFHSUserEnv is needed because the arduino-cli downloads compiler
# toolchains from the internet that have their interpreters pointed at
# /lib64/ld-linux-x86-64.so.2
  buildFHSUserEnv
  {
    inherit (pkg) name meta;

    runScript = "${pkg.outPath}/bin/arduino-cli";

    extraInstallCommands = ''
      mv $out/bin/$name $out/bin/arduino-cli
    '';

    targetPkgs = pkgs: with pkgs; [
      zlib
    ];
  }
else
  pkg
