{ stdenv, agda, fetchgit, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "33409120d071656f5198c658145889ae2e86249c";
  name = "categories-${version}";

  src = fetchgit {
    url = "https://github.com/copumpkin/categories.git";
    rev = version;
    sha256 = "15x834f7jn2s816b9vz8nm8p424ppzv6v9nayaawyl43qmaaaa5p";
  };

  buildDepends = [ AgdaStdlib ];
  sourceDirectories = [ "Categories" "Graphs" ];

  meta = {
    homepage = "https://github.com/copumpkin/categories";
    description = "Categories parametrized by morphism equality, in Agda";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    broken = true; # doesn't work due to new agdastdlib, see #9471
  };
})
