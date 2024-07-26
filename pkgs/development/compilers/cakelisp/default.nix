{ lib, stdenv, fetchgit, fetchpatch, gcc, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "cakelisp";
  # using unstable as it's the only version that builds against gcc-13
  version = "0.3.0-unstable-2023-12-18";

  src = fetchgit {
    url = "https://macoy.me/code/macoy/cakelisp";
    rev = "866fa2806d3206cc9dd398f0e86640db5be42bd6";
    hash = "sha256-vwMZUNy+updwk69ahA/D9LhO68eV6wH0Prq+o/i1Q/A=";
  };

  buildInputs = [ gcc ];

  postPatch = ''
    substituteInPlace runtime/HotReloading.cake \
        --replace '"/usr/bin/g++"' '"${gcc}/bin/g++"'
    substituteInPlace src/ModuleManager.cpp \
        --replace '"/usr/bin/g++"' '"${gcc}/bin/g++"'
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace Build.sh --replace '--export-dynamic' '-export_dynamic'
    substituteInPlace runtime/HotReloading.cake --replace '--export-dynamic' '-export_dynamic'
    substituteInPlace Bootstrap.cake --replace '--export-dynamic' '-export_dynamic'
  '';

  buildPhase = ''
    runHook preBuild
    ./Build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/cakelisp -t $out/bin
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://macoy.me/code/macoy/cakelisp";
  };

  meta = with lib; {
    description = "A performance-oriented Lisp-like language";
    homepage = "https://macoy.me/code/macoy/cakelisp";
    license = licenses.gpl3Plus;
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = [ maintainers.sbond75 ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
