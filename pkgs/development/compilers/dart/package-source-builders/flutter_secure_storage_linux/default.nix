{
  stdenv,
  jsoncpp,
  libsecret,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "flutter_secure_storage_linux";
  inherit version src;
  inherit (src) passthru;

  propagatedBuildInputs = [
    jsoncpp
    libsecret
  ];

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
