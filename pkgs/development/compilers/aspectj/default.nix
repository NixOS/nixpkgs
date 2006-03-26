{stdenv, fetchurl, jre}:

stdenv.mkDerivation {
  name = "aspectj-1.5.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/aspectj/aspectj-1.5.0.jar;
    md5 = "76d716f699cdd84049323992b21f02fb";
  };

  inherit jre;
  buildInputs = [jre];
}
