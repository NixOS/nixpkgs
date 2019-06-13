{ lib, fetchzip }:

let
  version = "3.2.0";
in fetchzip {
  name = "emacs-all-the-icons-fonts-${version}";

  url = "https://github.com/domtronn/all-the-icons.el/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/all-the-icons
  '';

  sha256 = "0ps8q9nkx67ivgn8na4s012360v36jwr0951rsg7j6dyyw9g41jq";

  meta = with lib; {
    description = "Icon fonts for emacs all-the-icons";
    longDescription = ''
      The emacs package all-the-icons provides icons to improve
      presentation of information in emacs. This package provides
      the fonts needed to make the package work properly.
    '';
    homepage = https://github.com/domtronn/all-the-icons.el;

    /*
    The fonts come under a mixture of licenses - the MIT license,
    SIL OFL license, and Apache license v2.0. See the GitHub page
    for further information.
    */
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ rlupton20 ];
  };
}
