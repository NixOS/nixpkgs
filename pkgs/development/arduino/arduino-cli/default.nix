{ stdenv, buildGoModule, fetchFromGitHub, buildFHSUserEnv }:

let

  pkg = buildGoModule rec {
    pname = "arduino-cli";
    version = "0.11.0";

    src = fetchFromGitHub {
      owner = "arduino";
      repo = pname;
      rev = version;
      sha256 = "0k9091ci7n7hl44nyzlxkmbwibgrrh9s6z7pgyj9v0mzxjmgz8h2";
    };

    subPackages = [ "." ];

    vendorSha256 = "1qybym95a38az8lk8bqc53ngn08hijckajv8v2giifc4q7sb17d2";

    doCheck = false;

    buildFlagsArray = [
      "-ldflags=-s -w -X github.com/arduino/arduino-cli/version.versionString=${version} -X github.com/arduino/arduino-cli/version.commit=unknown"
    ] ++ stdenv.lib.optionals stdenv.isLinux [ "-extldflags '-static'" ];

    meta = with stdenv.lib; {
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
