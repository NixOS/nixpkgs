{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "xteve";
  version = "2.2.0.200";

  src = fetchFromGitHub {
    owner = "xteve-project";
    repo = "xTeVe";
    rev = finalAttrs.version;
    hash = "sha256-hD4GudSkGZO41nR/CgcMg/SqKjpAO1yJDkfwa8AUges=";
  };

  vendorHash = "sha256-oPkSWpqNozfSFLIFsJ+e2pOL6CcR91YHbqibEVF2aSk=";

  meta = {
    description = "M3U Proxy for Plex DVR and Emby Live TV";
    homepage = "https://github.com/xteve-project/xTeVe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nrhelmi ];
    mainProgram = "xteve";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
