{stdenv, fetchurl, unzip, jre}:

stdenv.mkDerivation {
  name = "saxonb-8.8";
  src = fetchurl {
    url = http://mesh.dl.sourceforge.net/sourceforge/saxon/saxonb8-8j.zip;
    md5 = "35c4c376174cfe340f179d2e44dd84f0";
  };

  buildInputs = [unzip];

  buildCommand = "
    unzip $src -d $out
    ensureDir $out/bin
    cat > $out/bin/saxon8 <<EOF
#! $shell
export JAVA_HOME=${jre}
exec ${jre}/bin/java -jar $out/saxon8.jar \"\\$@\"
EOF
    chmod a+x $out/bin/saxon8
  ";
}
