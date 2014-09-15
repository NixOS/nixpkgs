{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "stix-otf-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/stixfonts/STIXv${version}-word.zip";
    sha256 = "1q35wbqn3nh78pdban9z37lh090c6p49q3d00zzxm0axxz66xy4q";
  };

  buildInputs = [unzip];

  phases = ["unpackPhase" "installPhase"];

  sourceRoot = "Fonts/STIX-Word";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp *.otf $out/share/fonts/opentype
  '';

  meta = with stdenv.lib; {
    homepage = http://www.stixfonts.org/;
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
