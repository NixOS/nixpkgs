{stdenv, fetchurl, jre}:

stdenv.mkDerivation rec {
  name = "aspectj-1.5.2";
  builder = ./builder.sh;

  src = fetchurl {
    url = "http://archive.eclipse.org/tools/aspectj/${name}.jar";
    sha256 = "1b3mx248dc1xka1vgsl0jj4sm0nfjsqdcj9r9036mvixj1zj3nmh";
  };

  inherit jre;
  buildInputs = [jre];

  meta = {
    homepage = http://www.eclipse.org/aspectj/;
    description = "A seamless aspect-oriented extension to the Java programming language";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.epl10;
  };
}
