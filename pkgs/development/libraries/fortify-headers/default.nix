{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation {
  pname = "fortify-headers";
  version = "1.1alpine3";

  # upstream only accessible via git - unusable during bootstrap, hence
  # extract from the alpine package
  src = fetchurl {
    url = "https://dl-cdn.alpinelinux.org/alpine/v3.18/main/x86_64/fortify-headers-1.1-r3.apk";
    name = "fortify-headers.tar.gz";  # ensure it's extracted as a .tar.gz
    hash = "sha256-8A8JcKHIBgXpUuIP4zs3Q1yBs5jCGd5F3H2E8UN/S2g=";
  };

  patches = [
    ./wchar-imports-skip.patch
    ./restore-macros.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r include/fortify $out/include

    runHook postInstall
  '';

  meta = {
    description = "Standalone header-based fortify-source implementation";
    homepage = "https://git.2f30.org/fortify-headers";
    license = lib.licenses.bsd0;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ris ];
  };
}
