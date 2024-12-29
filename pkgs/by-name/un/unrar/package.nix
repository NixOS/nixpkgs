{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unrar";
  version = "7.0.9";

  src = fetchzip {
    url = "https://www.rarlab.com/rar/unrarsrc-${finalAttrs.version}.tar.gz";
    stripRoot = false;
    hash = "sha256-lHh02uqHdX2Q9yyaGiHlkdBjlQE1tQyB44d39yDE4ls=";
  };

  sourceRoot = finalAttrs.src.name;

  postPatch = ''
    substituteInPlace unrar/makefile \
      --replace "CXX=" "#CXX=" \
      --replace "STRIP=" "#STRIP=" \
      --replace "AR=" "#AR="
  '';

  outputs = [ "out" "dev" ];

  # `make {unrar,lib}` call `make clean` implicitly
  # separate build into different dirs to avoid deleting them
  buildPhase = ''
    runHook preBuild

    cp -a unrar libunrar
    make -C libunrar lib
    make -C unrar -j1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 unrar/unrar -t $out/bin/
    install -Dm644 unrar/{acknow.txt,license.txt} -t $out/share/doc/unrar/

    install -Dm755 libunrar/libunrar.so -t $out/lib/
    install -Dm644 libunrar/dll.hpp -t $dev/include/unrar/

    runHook postInstall
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Utility for RAR archives";
    homepage = "https://www.rarlab.com/";
    license = licenses.unfreeRedistributable;
    mainProgram = "unrar";
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.all;
  };
})
