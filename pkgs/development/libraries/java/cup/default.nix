{ stdenv, fetchurl, jdk, ant } :

stdenv.mkDerivation rec {
  name = "java-cup-${version}";
  version = "11b-20160615";

  src = fetchurl {
    url = "http://www2.cs.tum.edu/projects/cup/releases/java-cup-src-${version}.tar.gz";
    sha256 = "1ymz3plngxclh7x3xr31537rvvak7lwyd0qkmnl1mkj5drh77rz0";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ jdk ant ];

  patches = [ ./javacup-0.11b_beta20160615-build-xml-git.patch ];

  buildPhase = "ant";

  installPhase = ''
    mkdir -p $out/{bin,share/{java,java-cup}}
    cp dist/java-cup-11b.jar $out/share/java-cup/
    cp dist/java-cup-11b-runtime.jar $out/share/java/
    cat > $out/bin/javacup <<EOF
    #! $shell
    exec ${jdk.jre}/bin/java -jar $out/share/java-cup/java-cup-11b.jar "\$@"
    EOF
    chmod a+x $out/bin/javacup
  '';

  meta = {
    homepage = http://www2.cs.tum.edu/projects/cup/;
    description = "LALR parser generator for Java";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
