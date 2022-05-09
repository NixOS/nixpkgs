{ callPackage, lib, stdenv, fetchurl, fetchFromGitLab, gawk }:

let startFPC = callPackage ./binary.nix { inherit stdenv; }; in

stdenv.mkDerivation rec {
  pname = "fpc";
  version = "unstable-2022-05-09";

  src = fetchFromGitLab {
    owner = "freepascal.org";
    repo = "fpc/source";
    rev = "4add05c625395fec0a2eda897f3f3dec67f760bd";
    sha256 = "sha256-kDR3pgV8IAK8NOJReUbXR28PHS3dyfj5EHYoWZZnX4Y=";
  };

  patches = [
    ./patches/0001-mark-paths-for-substitution-in-postPatch.patch
  ];

  glibc = stdenv.cc.libc.out;
  postPatch = ''
    # substitute the markers set by the mark-paths patch
    substituteInPlace compiler/systems/t_linux.pas --subst-var-by dynlinker-prefix "${glibc}"
    substituteInPlace compiler/systems/t_linux.pas --subst-var-by syslibpath "${glibc}/lib"
  '';

  makeFlags = [ "NOGDB=1" "FPC=${startFPC}/bin/fpc" ];

  buildInputs = [ startFPC gawk ];

  installFlags = [ "INSTALL_PREFIX=\${out}" ];

  postInstall = ''
    for i in $out/lib/fpc/*/ppc*; do
      ln -fs $i $out/bin/$(basename $i)
    done
    mkdir -p $out/lib/fpc/etc/
    $out/lib/fpc/*/samplecfg $out/lib/fpc/${version} $out/lib/fpc/etc/
  '';

  passthru = {
    bootstrap = startFPC;
  };

  meta = with lib; {
    description = "Free Pascal Compiler from a source distribution";
    homepage = "https://www.freepascal.org";
    maintainers = with maintainers; [ raskin superherointj ];
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
  };
}
