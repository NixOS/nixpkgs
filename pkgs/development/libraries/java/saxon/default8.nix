{stdenv, fetchurl, unzip, jre}:

stdenv.mkDerivation {
  name = "saxonb-8.8";
  src = fetchurl {
    url = mirror://sourceforge/saxon/saxonb8-8j.zip;
    sha256 = "15bzrfyd2f1045rsp9dp4znyhmizh1pm97q8ji2bc0b43q23xsb8";
  };

  buildInputs = [unzip];

  buildCommand = "
    unzip $src -d $out
    mkdir -p $out/bin
    cat > $out/bin/saxon8 <<EOF
#! $shell
export JAVA_HOME=${jre}
exec ${jre}/bin/java -jar $out/saxon8.jar \"\\$@\"
EOF
    chmod a+x $out/bin/saxon8
  ";

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
