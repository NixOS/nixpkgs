{stdenv, fetchurl, fontforge, pythonPackages, python}:

stdenv.mkDerivation rec {
  pname = "liberationsansnarrow";
  version = "1.07.6";
  name = "${pname}-${version}";

  src = fetchurl {
    url = https://github.com/liberationfonts/liberation-sans-narrow/files/2579430/liberation-narrow-fonts-1.07.6.tar.gz;
    sha256 = "1j2ilz2kb4kpl1wky3m7ak6axnlfn44anj9dhpbr1madh2682i2j";
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
