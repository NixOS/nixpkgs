{ lib, stdenv, buildGoModule, fetchFromGitHub, buildFHSUserEnv, installShellFiles }:

let

  pkg = buildGoModule rec {
    pname = "arduino-cli";
    version = "0.29.0";

    src = fetchFromGitHub {
      owner = "arduino";
      repo = pname;
      rev = version;
      sha256 = "sha256-jew4KLpOOXE9N/h4qFqof8y26DQrvm78E/ARbbwocD4=";
    };

    nativeBuildInputs = [
      installShellFiles
    ];

    subPackages = [ "." ];

    vendorSha256 = "sha256-BunonnjzGnpcmGJXxEQXvjJLGvdSXUOK9zAhXoAemHY=";

    doCheck = false;

    ldflags = [
      "-s" "-w" "-X github.com/arduino/arduino-cli/version.versionString=${version}" "-X github.com/arduino/arduino-cli/version.commit=unknown"
    ] ++ lib.optionals stdenv.isLinux [ "-extldflags '-static'" ];

    postInstall = ''
      export HOME="$(mktemp -d)"
      for s in {bash,zsh,fish}; do
        $out/bin/arduino-cli completion $s > completion.$s
        installShellCompletion --cmd arduino-cli --$s completion.$s
      done
      unset HOME
    '';

    meta = with lib; {
      inherit (src.meta) homepage;
      description = "Arduino from the command line";
      changelog = "https://github.com/arduino/arduino-cli/releases/tag/${version}";
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
      cp -r ${pkg.outPath}/share $out/share
    '';
    passthru.pureGoPkg = pkg;

    targetPkgs = pkgs: with pkgs; [
      zlib
    ];
  }
else
  pkg
