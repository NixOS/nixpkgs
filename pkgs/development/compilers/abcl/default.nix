{stdenv, fetchurl, ant, jre, jdk}:
stdenv.mkDerivation rec {
  pname = "abcl";
  version = "1.8.0";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "https://common-lisp.net/project/armedbear/releases/${version}/${pname}-src-${version}.tar.gz";
    sha256 = "0zr5mmqyj484vza089l8vc88d07g0m8ymxzglvar3ydwyvi1x1qx";
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
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/abcl,lib/abcl}
    cp -r README COPYING CHANGES examples/  "$out/share/doc/abcl/"
    cp -r dist/*.jar contrib/ "$out/lib/abcl/"

    echo "#! ${stdenv.shell}" >> "$out/bin/abcl"
    echo "${jre}/bin/java -cp \"$out/lib/abcl/abcl.jar:$out/lib/abcl/abcl-contrib.jar:\$CLASSPATH\" org.armedbear.lisp.Main \"\$@\"" >> "$out/bin/abcl"
    chmod a+x "$out"/bin/*
  '';
  buildInputs = [jre ant jdk jre];
  meta = {
    inherit version;
    description = ''A JVM-based Common Lisp implementation'';
    license = stdenv.lib.licenses.gpl3 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://common-lisp.net/project/armedbear/";
  };
}
