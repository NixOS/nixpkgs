{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation {
  pname = "fortify-headers";
  version = "1.1alpine1";

  # upstream only accessible via git - unusable during bootstrap, hence
  # extract from the alpine package
  src = fetchurl {
    url = "https://dl-cdn.alpinelinux.org/alpine/v3.17/main/x86_64/fortify-headers-1.1-r1.apk";
    name = "fortify-headers.tar.gz";  # ensure it's extracted as a .tar.gz
    hash = "sha256-A67NzUv+dldARY+MTaoVnezTg+Es8ZK/b7XOxA6KzpI=";
  };

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
