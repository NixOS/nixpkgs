{ stdenv, fetchurl, unzip, ant, jdk, makeWrapper }:

let
  version = "3.7.2";
  date    = "201202080800";
in

stdenv.mkDerivation rec {
  name = "ecj-${version}";

  src = fetchurl {
    url = "http://eclipse.ialto.org/eclipse/downloads/drops/R-${version}-${date}/ecjsrc-${version}.jar";
    sha256 = "0swyysbyfmv068x8q1c5jqpwk5zb4xahg17aypx5rwb660f8fpbm";
  };

  buildInputs = [ unzip ant jdk makeWrapper ];

  unpackPhase = ''
    mkdir "${name}"
    cd "${name}"
    unzip "$src"
  '';

  # Use whatever compiler Ant knows.
  buildPhase = "ant build";

  installPhase = ''
    mkdir -pv $out/share/java
    cp -v *.jar $out/share/java

    mkdir -pv $out/bin
    makeWrapper ${jdk.jre}/bin/java $out/bin/ecj \
      --add-flags "-cp $out/share/java/ecj.jar org.eclipse.jdt.internal.compiler.batch.Main"

    # Add a setup hook that causes Ant to use the ECJ.
    mkdir -p $out/nix-support
    cat <<EOF > $out/nix-support/setup-hook
    export NIX_ANT_ARGS="-Dbuild.compiler=org.eclipse.jdt.core.JDTCompilerAdapter \$NIX_ANT_ARGS"
    EOF
  '';

  meta = {
    description = "The Eclipse Compiler for Java (ECJ)";

    longDescription = ''
      ECJ is an incremental Java compiler.  Implemented as an Eclipse
      builder, it is based on technology evolved from VisualAge for Java
      compiler.  In particular, it allows users to run and debug code which
      still contains unresolved errors.
    '';

    homepage = http://www.eclipse.org/jdt/core/index.php;

    # http://www.eclipse.org/legal/epl-v10.html (free software, copyleft)
    license = "EPLv1.0";

    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
