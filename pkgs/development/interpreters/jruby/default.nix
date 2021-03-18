{ lib, stdenv, callPackage, fetchFromGitHub, makeWrapper, jre, maven, ant, jrubyVersion ? "9.2.16.0" }:

let
  # The version number here is whatever is reported by the RUBY_VERSION string
  rubyVersion = callPackage ../ruby/ruby-version.nix { } "2" "5" "7" "";
  jruby-src = fetchFromGitHub {
    owner = "jruby";
    repo = "jruby";
    rev = jrubyVersion;
    sha256 = "14zs1xr9rb7ydna7kfr2xvsvgwpm8lr5ngmb8dqgdv1hq687h6wz";
  };
  # Nixpkgs works by disallowing Internet access in order to enforce
  # reproducibility. One way around that however is if your build is already
  # binary reproducible, which you can toggle by specifying outputHash.
  # We create a maven repository (~/.m2) for use in the build further down.
  maven-repository = stdenv.mkDerivation {
    name = "jruby-maven-repository";
    buildInputs = [ jre maven ];

    src = jruby-src;
    buildPhase = ''
      mkdir $out
      mvn -Pdist -Dmaven.repo.local=$out -Dmaven.wagon.rto=5000
    '';
    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      find $out -type f -name '*.lastUpdated' -delete
      find $out -type f -name resolver-status.properties -delete
      find $out -type f -name _remote.repositories -delete

      # This check here is placed because I had trouble with find actually deleting the
      # desired files. Originally, I had used finds `-or` command to chain the above
      # but it was failing to perform the desired action. This is a little sanity check.
      lines=$(find $out -type f \
        -name '*.lastUpdated' -or \
        -name resolver-status.properties -or \
        -name _remote.repositories | wc -l)
      if [ $lines -ne 0 ]; then
        echo "Failed to delete files that cause output hash to change"
        exit 1
      fi
    '';
    # don't do any fixup
    dontFixup = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0fl18x9ax0aqgzzgx06frgwclpx7di5apmy7mzdv6x2x1wmlw90y";
  };
  jruby = stdenv.mkDerivation rec {
    pname = "jruby";

    version = jrubyVersion;

    src = jruby-src;

    buildInputs = [ makeWrapper maven ant jre ];

    buildPhase = ''
      echo "Using repository ${maven-repository}"
      # We make sure to avoid installation since the maven repository is read-only now
      mvn -Dmaven.install.skip=true -Pdist --offline -Dmaven.repo.local=${maven-repository}
      mkdir ./dist
      tar -xzvf ./maven/jruby-dist/target/jruby-dist-*-bin.tar.gz --strip-components=1 -C ./dist
      cd ./dist
    '';

    installPhase = ''
      mkdir -pv $out/docs
      mv * $out
      rm $out/bin/*.{bat,dll,exe,sh}
      mv $out/COPYING $out/LICENSE* $out/docs

      for i in $out/bin/jruby{,.bash}; do
        wrapProgram $i \
          --set JAVA_HOME ${jre.home}
      done

      ln -s $out/bin/jruby $out/bin/ruby

      # Bundler tries to create this directory
      mkdir -pv $out/${passthru.gemPath}
      mkdir -p $out/nix-support
      cat > $out/nix-support/setup-hook <<EOF
        addGemPath() {
          addToSearchPath GEM_PATH \$1/${passthru.gemPath}
        }

        addEnvHooks "$hostOffset" addGemPath
      EOF
    '';

    postFixup = ''
      PATH=$out/bin:$PATH patchShebangs $out/bin
    '';

    passthru = rec {
      rubyEngine = "jruby";
      gemPath = "lib/${rubyEngine}/gems/${rubyVersion.libDir}";
      libPath = "lib/${rubyEngine}/${rubyVersion.libDir}";
    };

    meta = with lib; {
      description = "Ruby interpreter written in Java";
      homepage = "http://jruby.org/";
      license = with licenses; [ cpl10 gpl2 lgpl21 ];
      platforms = platforms.unix;
      maintainers = [ maintainers.fzakaria ];
    };
  };
in jruby.overrideAttrs (oldAttrs: {
  passthru = oldAttrs.passthru // {
    devEnv = callPackage ../ruby/dev.nix { ruby = jruby; };
  };
})
