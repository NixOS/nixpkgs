{
  stdenv,
  fetchurl,
}:

{ version, src, ... }:

let
  # MDK SDK required by fvp plugin
  mdk-sdk = fetchurl {
    url = "https://sourceforge.net/projects/mdk-sdk/files/nightly/mdk-sdk-linux-x64.tar.xz";
    hash = "sha256-eFfcMNgjns89BS3LxJ0Ts1qnaQLn92hrKxkXeAsJ1Z4=";
  };
in
stdenv.mkDerivation {
  pname = "fvp";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    # Pre-provision the MDK SDK by extracting it directly to avoid downloading during build
    mkdir -p linux
    tar -xf ${mdk-sdk} -C linux
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r ./* $out/

    runHook postInstall
  '';
}
