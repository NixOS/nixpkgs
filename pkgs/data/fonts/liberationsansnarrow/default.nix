{stdenv, fetchurl, fontforge, pythonPackages, python}:

stdenv.mkDerivation rec {
  pname = "liberationsansnarrow";
  version = "1.07.3";
  name = "${pname}";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/liberation-fonts/liberation-fonts-ttf-${version}.tar.gz";
    sha256 = "0qkr7n97jmj4q85jr20nsf6n5b48j118l9hr88vijn22ikad4wsp";
  };

  buildInputs = [ fontforge pythonPackages.fonttools python ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v $(find . -name '*Narrow*.ttf') $out/share/fonts/truetype

    mkdir -p "$out/doc/${name}"
    cp -v AUTHORS ChangeLog COPYING License.txt README "$out/doc/${name}" || true
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
    homepage = https://fedorahosted.org/liberation-fonts/;
    maintainers = [ maintainers.leenaars
    ];
  };
}
