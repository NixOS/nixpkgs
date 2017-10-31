{stdenv, fetchzip}:

let
  version = "1.7.1";
in fetchzip rec {
  name = "fantasque-sans-mono-${version}";

  url = "https://github.com/belluzj/fantasque-sans/releases/download/v${version}/FantasqueSansMono.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.otf    -d $out/share/fonts/opentype
    unzip -j $downloadedFile README.md -d $out/share/doc/${name}
  '';

  sha256 = "1sjdpnxyjdbqxzrylzkynxh1bmicc71h3pmwmr3a3cq0h53g28z0";

  meta = with stdenv.lib; {
    homepage = https://github.com/belluzj/fantasque-sans;
    description = "A font family with a great monospaced variant for programmers";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
