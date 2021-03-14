{ lib, stdenv, buildGoModule, fetchFromGitHub, buildFHSUserEnv }:

let

  pkg = buildGoModule rec {
    pname = "arduino-cli";
    version = "0.12.1";

    src = fetchFromGitHub {
      owner = "arduino";
      repo = pname;
      rev = version;
      sha256 = "1jlxs4szss2250zp8rz4bislgnzvqhxyp6z48dhx7zaam03hyf0w";
    };

    subPackages = [ "." ];

    vendorSha256 = "03yj2iar63qm10fw3jh9fvz57c2sqcmngb0mj5jkhbnwf8nl7mhc";

    doCheck = false;

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
