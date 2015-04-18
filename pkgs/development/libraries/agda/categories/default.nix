{ stdenv, agda, fetchgit, AgdaStdlib }:

agda.mkDerivation (self: rec {
  version = "33409120d071656f5198c658145889ae2e86249c";
  name = "categories-${version}";

  src = fetchgit {
    url = "https://github.com/copumpkin/categories.git";
    rev = version;
    sha256 = "cb7e8c911e10ab582c077208f5f6675711c0d65f0d9d679639d4b67a467cc4de";
  };

  buildDepends = [ AgdaStdlib ];
  sourceDirectories = [ "Categories" "Graphs" ];

  meta = {
    homepage = "https://github.com/copumpkin/categories";
    description = "Categories parametrized by morphism equality, in Agda";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
