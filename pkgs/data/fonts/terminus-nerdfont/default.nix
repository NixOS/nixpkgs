{ lib, fetchzip }:

let
  version = "2.0.0";
in fetchzip {
  name = "terminus-nerdfont-${version}";

  url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/Terminus.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/terminus-nerdfont
    unzip -j $downloadedFile -d $out/share/fonts/terminus-nerdfont
  '';

  sha256 = "036i1qwwrb0r8hvcjf3h34w0g7mbsmngvrjic98jgikbz3i2f46c";

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
