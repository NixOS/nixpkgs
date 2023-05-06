{ stdenv
, lib
, fetchurl
, ant
, jre
, jdk
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "abcl";
  version = "1.9.1";

  src = fetchurl {
    url = "https://common-lisp.net/project/armedbear/releases/${version}/${pname}-src-${version}.tar.gz";
    sha256 = "sha256-pbxnfJRB9KgzwgpUG93Rb/+SZIRmkd6aHa9mmfj/EeI=";
  };

  configurePhase = ''
    runHook preConfigure

    mkdir nix-tools
    export PATH="$PWD/nix-tools:$PATH"
    echo "echo nix-builder.localdomain" > nix-tools/hostname
    chmod a+x nix-tools/*

    hostname

    runHook postConfigure
  '';

  buildInputs = [ jre ];

  # note for the future:
  # if you use makeBinaryWrapper, you will trade bash for glibc, the closure will be slightly larger
  nativeBuildInputs = [ makeWrapper ant jdk ];

  buildPhase = ''
    runHook preBuild

    ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{bin,share/doc/abcl,lib/abcl}
    cp -r README COPYING CHANGES examples/  "$out/share/doc/abcl/"
    cp -r dist/*.jar contrib/ "$out/lib/abcl/"

    makeWrapper ${jre}/bin/java $out/bin/abcl \
      --prefix CLASSPATH : $out/lib/abcl/abcl.jar \
      --prefix CLASSPATH : $out/lib/abcl/abcl-contrib.jar \
      ${lib.optionalString (lib.versionAtLeast jre.version "17")
        # Fix for https://github.com/armedbear/abcl/issues/484
        "--add-flags --add-opens=java.base/java.util.jar=ALL-UNNAMED \\"
      }
      --add-flags org.armedbear.lisp.Main

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "A JVM-based Common Lisp implementation";
    license = lib.licenses.gpl3 ;
    maintainers = lib.teams.lisp.members;
    platforms = lib.platforms.linux;
    homepage = "https://common-lisp.net/project/armedbear/";
  };
}
