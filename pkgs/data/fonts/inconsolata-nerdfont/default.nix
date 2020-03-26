{ lib, fetchzip }:

let
  version = "2.0.0";
in fetchzip {
  name = "inconsolata-nerdfont-${version}";

  url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/Inconsolata.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/inconsolata-nerdfont
    unzip -j $downloadedFile -d $out/share/fonts/inconsolata-nerdfont
  '';

  sha256 = "06i1akjblqd038cn5lvz67lwp6afpv31vqcfdihp66qisgbgm4w9";

  meta = with lib; {
    description = ''
      Nerd Fonts is a project that attempts to patch as many developer targeted
      and/or used fonts as possible. The patch is to specifically add a high
      number of additional glyphs from popular 'iconic fonts' such as Font
      Awesome, Devicons, Octicons, and others.
    '';
    homepage = https://github.com/ryanoasis/nerd-fonts;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
