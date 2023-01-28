# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "6.2";
in (fetchzip {
  name = "fira-code-${version}";

  url = "https://github.com/tonsky/FiraCode/releases/download/${version}/Fira_Code_v${version}.zip";

  sha256 = "0l02ivxz3jbk0rhgaq83cqarqxr07xgp7n27l0fh8fbgxwi52djl";

  meta = with lib; {
    homepage = "https://github.com/tonsky/FiraCode";
    description = "Monospace font with programming ligatures";
    longDescription = ''
      Fira Code is a monospace font extending the Fira Mono font with
      a set of ligatures for common programming multi-character
      combinations.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  # only extract the variable font because everything else is a duplicate
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile '*-VF.ttf' -d $out/share/fonts/truetype
  '';
})
