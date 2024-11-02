{ lib
, stdenv
, fetchFromGitHub
, python3
, writeText
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "libopencm3";
  version = "unstable-2023-08-16";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "32a169207775d6c53c536d46b78ecf8eca3fdd18";
    hash = "sha256-8lE63woxooREL0r+AE0/2qozyIA+HFipoDu1dLOLzqA=";
  };

  nativeBuildInputs = [ python3 ];

  postPatch = ''
    patchShebangs scripts/
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include/
    cp -r include/libopencm3/ include/libopencmsis/ $out/include/
    install -Dm444 lib/*.a lib/*.ld -t $out/lib/
    # Install some more files to make it actually useful
    # FHS violation, I know...
    install -Dm444 mk/* -t $out/mk/
    install -Dm444 ld/devices.data ld/linker.ld.S -t $out/ld/
    install -Dm555 scripts/genlink.py -t $out/scripts/
    runHook postInstall
  '';

  setupHook = writeText "setup-hook.sh" ''
    addOpencm3Dir () {
      export MAKEFLAGS+=" OPENCM3_DIR=@out@"
    }
    addEnvHooks "$hostOffset" addOpencm3Dir
  '';

  passthru.updateScript = unstableGitUpdater { url = src.gitRepoUrl; };

  meta = with lib; {
    description = "Open-source lowlevel hardware library for various ARM Cortex-M microcontrollers";
    longDescription = ''
      Libopencm3 packaged for easy integration with Nixpkgs. A nix-shell can be launched with:

        nix-shell -E '(import <nixpkgs> { }).pkgsCross.arm-embedded.callPackage ({ mkShell, libopencm3 }: mkShell { buildInputs = [ libopencm3 ]; }) { }'

      If you prefer using it as source code, use ${pname}.src instead.
    '';
    homepage = "https://libopencm3.org/";
    license = licenses.lgpl3;
    platforms = [ "arm-none" ];
    maintainers = with maintainers; [ chuangzhu ];
  };
}
