{ stdenv, agda, fetchgit }:

agda.mkDerivation (self: rec {
  version = "8a06162a8f0f7df308458db91d720cf8f7345d69";
  name = "Agda-Sheaves-${version}";
  src = fetchgit {
    url = "https://github.com/jonsterling/Agda-Sheaves.git";
    rev = version;
    sha256 = "1gjffyyi4gk9z380yw2wm0jg0a01zy8dnw7jrcc7222swisk5s2d";
  };

  everythingFile = "sheaves.agda";
  topSourceDirectories = [ "../$sourceRoot" ];
  sourceDirectories = [];

  meta = {
    homepage = https://github.com/jonsterling/Agda-Sheaves;
    description = "Sheaves in Agda";
    license = stdenv.lib.licenses.cc-by-40;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ ];
    broken = true;  # replaced by constructive-sheaf-semantics
  };
})
