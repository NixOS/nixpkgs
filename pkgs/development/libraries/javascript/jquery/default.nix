{ stdenv, fetchurl, compressed ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "jquery-1.11.1";

  src = if compressed then
    fetchurl {
      url = "http://code.jquery.com/${name}.min.js";
      sha256 = "0hgly37jhg0n5cqlx3ylmwcxkxmbkvv07f9z9pm94jyxq7gcc2sl";
    }
    else
    fetchurl {
      url = "http://code.jquery.com/${name}.js";
      sha256 = "1g7nhy8dwzzai7h7m800fsig4gzw34kjxxbpqdac2y8ch9586a9h";
    };

  unpackPhase = "true";

  installPhase =
    ''
      mkdir -p "$out/js"
      cp -v "$src" "$out/js/jquery.js"
      ${optionalString compressed ''
        (cd "$out/js" && ln -s jquery.js jquery.min.js)
      ''}
    '';

  meta = with stdenv.lib; {
    description = "JavaScript library designed to simplify the client-side scripting of HTML";
    homepage = http://jquery.com/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
