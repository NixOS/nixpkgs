{
  stdenv,
  libsecret,
  jsoncpp,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "flutter-secure-storage-linux";
  inherit version src;
  inherit (src) passthru;

  propagatedBuildInputs = [
    libsecret
    jsoncpp
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    ln -s '${src}'/* "$out"

    runHook postInstall
  '';

  __structuredAttrs = true;
}
