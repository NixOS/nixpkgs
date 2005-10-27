{stdenv, fetchurl, libxml2}:

stdenv.mkDerivation {
  name = "neon-0.24.7";
  src = fetchurl {
    url = http://www.webdav.org/neon/neon-0.24.7.tar.gz;
    md5 = "5108bcbe41de4afe2e19cc58500fb9f2";
  };
  buildInputs = [libxml2];
}
