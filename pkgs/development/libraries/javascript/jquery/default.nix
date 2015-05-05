{ stdenv, fetchurl, compressed ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "jquery-1.11.2";

  src = if compressed then
    fetchurl {
      url = "http://code.jquery.com/${name}.min.js";
      sha256 = "1h09zz6cjm66g30wa7c41by1jswx9gjpgqgbxln0dv2v55fjkk9f";
    }
    else
    fetchurl {
      url = "http://code.jquery.com/${name}.js";
      sha256 = "098gnzndmmjygpsfywxgmb0vi42b882pwpby77gqkrd2nwsp1hjq";
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
