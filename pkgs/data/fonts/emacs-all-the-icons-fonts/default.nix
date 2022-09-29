# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "5.0.0";
in (fetchzip {
  name = "emacs-all-the-icons-fonts-${version}";

  url = "https://github.com/domtronn/all-the-icons.el/archive/${version}.zip";

  sha256 = "0vc9bkm4pcc05llcd2c9zr3d88h3zmci0izla5wnw8hg1n0rsrii";

  meta = with lib; {
    description = "Icon fonts for emacs all-the-icons";
    longDescription = ''
      The emacs package all-the-icons provides icons to improve
      presentation of information in emacs. This package provides
      the fonts needed to make the package work properly.
    '';
    homepage = "https://github.com/domtronn/all-the-icons.el";

    /*
    The fonts come under a mixture of licenses - the MIT license,
    SIL OFL license, and Apache license v2.0. See the GitHub page
    for further information.
    */
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ rlupton20 ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/all-the-icons
  '';
})
