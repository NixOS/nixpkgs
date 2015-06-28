{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "fantasque-sans-mono-${version}";
  version = "1.6.5";

  src = fetchurl {
    url = "https://github.com/belluzj/fantasque-sans/releases/download/v${version}/FantasqueSansMono.zip";
    sha256 = "19a82xlbcnd7dxqmpp03b62gjvi33bh635r0bjw2l09lgir6alym";
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
