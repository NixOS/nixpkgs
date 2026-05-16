{
  stdenv,
  lib,
  fetchFromGitHub,
  jq,
  nix,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terranix";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "mrVanDalo";
    repo = "terranix";
    rev = finalAttrs.version;
    sha256 = "sha256-1Pu2j5xsBTuoyga08ZVf+rKp3FOMmJh/0fXen/idOrA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,core,modules,lib}
    mv bin core modules lib share $out/

    wrapProgram $out/bin/terranix-doc-json \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          nix
        ]
      }
  '';

  meta = {
    description = "NixOS like terraform-json generator";
    homepage = "https://terranix.org";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      mrVanDalo
      sshine
    ];
  };
})
