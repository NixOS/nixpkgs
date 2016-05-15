{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "fantasque-sans-mono-${version}";
  version = "1.7.1";

  src = fetchurl {
    url = "https://github.com/belluzj/fantasque-sans/releases/download/v${version}/FantasqueSansMono.zip";
    sha256 = "0lkky7mmpq6igpjh7lsv30xjx62mwlx27gd9zwcyv3mp2d2b5cvb";
  };

  buildInputs = [unzip];
  phases = ["unpackPhase" "installPhase"];

  unpackCmd = ''
    mkdir -p ${name}
    unzip -qq -d ${name} $src
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    cp -v "OTF/"*.otf $out/share/fonts/opentype
    cp -v README.md $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/belluzj/fantasque-sans;
    description = "A font family with a great monospaced variant for programmers";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
