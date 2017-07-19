{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "emacs-all-the-icons-fonts-${version}";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "domtronn";
    repo = "all-the-icons.el";
    rev = version;
    sha256 = "0h8a2jvn2wfi3bqd35scmhm8wh20mlk09sy68m1whi9binzkm8rf";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/all-the-icons
    for font in $src/fonts/*.ttf; do cp $font $out/share/fonts/all-the-icons; done
  '';

  meta = with stdenv.lib; {
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
