{lib, stdenv, fetchurl, ant, jre, jdk}:
stdenv.mkDerivation rec {
  pname = "abcl";
  version = "1.9.0";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "https://common-lisp.net/project/armedbear/releases/${version}/${pname}-src-${version}.tar.gz";
    sha256 = "sha256-oStchPKINL2Yjjra4K0q1MxsRR2eRPPAhT0AcVjBmGk=";
  };
  configurePhase = ''
    mkdir nix-tools
    export PATH="$PWD/nix-tools:$PATH"
    echo "echo nix-builder.localdomain" > nix-tools/hostname
    chmod a+x nix-tools/*

    hostname
  '';
  buildPhase = ''
    ant
  '';
  # Fix for https://github.com/armedbear/abcl/issues/484
  javaOpts =
    lib.optionalString
      (lib.versionAtLeast jre.version "17")
      "--add-opens=java.base/java.util.jar=ALL-UNNAMED";
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/abcl,lib/abcl}
    cp -r README COPYING CHANGES examples/  "$out/share/doc/abcl/"
    cp -r dist/*.jar contrib/ "$out/lib/abcl/"

    echo "#! ${stdenv.shell}" >> "$out/bin/abcl"
    echo "${jre}/bin/java $javaOpts -cp \"$out/lib/abcl/abcl.jar:$out/lib/abcl/abcl-contrib.jar:\$CLASSPATH\" org.armedbear.lisp.Main \"\$@\"" >> "$out/bin/abcl"
    chmod a+x "$out"/bin/*
  '';
  buildInputs = [jre ant jdk jre];
  meta = {
    description = "A JVM-based Common Lisp implementation";
    license = lib.licenses.gpl3 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "https://common-lisp.net/project/armedbear/";
  };
}
