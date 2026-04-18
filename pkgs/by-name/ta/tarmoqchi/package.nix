{
  lib,
  fetchFromGitHub,
  buildGoModule,
  fetchurl,
  ...
}:

buildGoModule (finalAttrs: {
  pname = "tarmoqchi";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/floss-uz-community/tarmoqchi/archive/refs/tags/Tarmoqchi-${finalAttrs.version}.tar.gz";
    hash = "sha256-II8MME5Lsp5aO3szwm/jF9M/ON95ZVLnt81KAS4p6nE=";

  };
  __structuredAttrs = true;

  postInstall = ''
    mv $out/bin/cli $out/bin/tarmoqchi
  '';
  vendorHash = "sha256-0Qxw+MUYVgzgWB8vi3HBYtVXSq/btfh4ZfV/m1chNrA=";
  modRoot = "cli";

  meta = {
    description = "HTTP & TCP tunnelling";
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "tarmoqchi";
    homepage = "https://tarmoqchi.uz";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [
      orzklv
      wolfram444
    ];
  };

})
