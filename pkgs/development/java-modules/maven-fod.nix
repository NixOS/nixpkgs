{ lib
, stdenv
, maven
}:

{ src
, patches ? [ ]
, pname
, version
, mvnHash ? ""
, mvnFetchExtraArgs ? { }
, mvnParameters ? ""
, ...
} @args:

# originally extracted from dbeaver
# created to allow using maven packages in the same style as rust

stdenv.mkDerivation (rec {
  fetchedMavenDeps = stdenv.mkDerivation ({
    name = "${pname}-${version}-maven-deps";
    inherit src;

    buildInputs = [
      maven
    ];

    buildPhase = ''
      mvn package -Dmaven.repo.local=$out/.m2 ${mvnParameters}
    '';

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete
    '';

    # don't do any fixup
    dontFixup = true;
    outputHashAlgo = if mvnHash != "" then null else "sha256";
    outputHashMode = "recursive";
    outputHash = mvnHash;
  } // mvnFetchExtraArgs);

  buildPhase = ''
    runHook preBuild

    mvnDeps=$(cp -dpR ${fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)
    mvn package --offline "-Dmaven.repo.local=$mvnDeps/.m2" ${mvnParameters}

    runHook postBuild
  '';
} // builtins.removeAttrs args [ "mvnFetchExtraArgs" ])
