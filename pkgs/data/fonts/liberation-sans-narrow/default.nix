{ stdenv, fetchFromGitHub, fontforge, pythonPackages, python }:

stdenv.mkDerivation rec {
  pname = "liberation-sans-narrow";
  version = "1.07.6";

  src = fetchFromGitHub {
    owner = "liberationfonts";
    repo = pname;
    rev = version;
    sha256 = "1qw554jbdnqkg6pjjl4cqkgsalq3398kzvww2naw30vykcz752bm";
  };

  buildInputs = [ fontforge pythonPackages.fonttools python ];

  installPhase = ''
    find . -name '*Narrow*.ttf' -exec install -m444 -Dt $out/share/fonts/truetype {} \;
    install -m444 -Dt $out/doc/${pname}-${version} AUTHORS ChangeLog COPYING License.txt README.rst
  '';

  meta = with stdenv.lib; {
    description = "Liberation Sans Narrow Font Family is a replacement for Arial Narrow";
    longDescription = ''
      Liberation Sans Narrow is a font originally created by Ascender
      Inc and licensed to Oracle Corporation under a GPLv2 license. It is
      metrically compatible with the commonly used Arial Narrow fonts
      on Microsoft systems. It is no longer distributed with the
      latest versions of the Liberation Fonts, as Red Hat has changed the
      license to the Open Font License.
    '';

    license = licenses.gpl2;
    homepage = https://github.com/liberationfonts;
    maintainers = [ maintainers.leenaars ];
  };
}
