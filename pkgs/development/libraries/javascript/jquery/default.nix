{ stdenv, fetchurl, compressed ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "jquery-1.11.3";

  src = if compressed then
    fetchurl {
      url = "http://code.jquery.com/${name}.min.js";
      sha256 = "1f4glgxxn3jnvry3dpzmazj3207baacnap5w20gr2xlk789idfgc";
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
