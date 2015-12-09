{ buildErlang, fetchgit }:

buildErlang {
  name = "aleppo";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/inaka/aleppo.git";
    sha256 = "06n36022q3zswk4wgm20kf6vrmkv8pi7g06bqb5ad76ivj08hmhv";
  };
}