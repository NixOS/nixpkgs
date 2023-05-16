<<<<<<< HEAD
{ lib, stdenv, callPackage, fetchurl, mkRubyVersion, makeBinaryWrapper, jre }:

let
  # The version number here is whatever is reported by the RUBY_VERSION string
  rubyVersion = mkRubyVersion "3" "1" "4" "";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jruby";
  version = "9.4.3.0";

  src = fetchurl {
    url = "https://s3.amazonaws.com/jruby.org/downloads/${finalAttrs.version}/jruby-bin-${finalAttrs.version}.tar.gz";
    hash = "sha256-sJfgjFZp6KGIKI4RORHRK0rSvWeiwgnW36hEXWOk2Mk=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    mkdir -pv $out/share/jruby/docs
    mv * $out
    rm $out/bin/*.{bat,dll,exe,sh}
    mv $out/samples $out/share/jruby/
    mv $out/BSDL $out/COPYING $out/LEGAL $out/LICENSE* $out/share/jruby/docs/

    for i in $out/bin/jruby; do
      wrapProgram $i \
        --set JAVA_HOME ${jre.home}
    done

    ln -s $out/bin/jruby $out/bin/ruby

    # Bundler tries to create this directory
    mkdir -pv $out/${finalAttrs.passthru.gemPath}
    mkdir -p $out/nix-support
    cat > $out/nix-support/setup-hook <<EOF
      addGemPath() {
        addToSearchPath GEM_PATH \$1/${finalAttrs.passthru.gemPath}
      }

      addEnvHooks "$hostOffset" addGemPath
    EOF
=======
{ lib, stdenv, callPackage, fetchurl, makeWrapper, jre }:

let
# The version number here is whatever is reported by the RUBY_VERSION string
rubyVersion = callPackage ../ruby/ruby-version.nix {} "2" "5" "7" "";
jruby = stdenv.mkDerivation rec {
  pname = "jruby";

  version = "9.3.9.0";

  src = fetchurl {
    url = "https://s3.amazonaws.com/jruby.org/downloads/${version}/jruby-bin-${version}.tar.gz";
    sha256 = "sha256-JR5t2NHS+CkiyMd414V+G++C/lyiz3e8CTVkIdCwWrg=";
  };

  nativeBuildInputs = [ makeWrapper ];

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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  postFixup = ''
    PATH=$out/bin:$PATH patchShebangs $out/bin
  '';

  passthru = rec {
    rubyEngine = "jruby";
    gemPath = "lib/${rubyEngine}/gems/${rubyVersion.libDir}";
    libPath = "lib/${rubyEngine}/${rubyVersion.libDir}";
<<<<<<< HEAD
    devEnv = callPackage ../ruby/dev.nix {
      ruby = finalAttrs.finalPackage;
    };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Ruby interpreter written in Java";
<<<<<<< HEAD
    homepage = "https://www.jruby.org/";
    changelog = "https://github.com/jruby/jruby/releases/tag/${version}";
    license = with licenses; [ cpl10 gpl2 lgpl21 ];
    platforms = jre.meta.platforms;
    maintainers = [ maintainers.fzakaria ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
=======
    homepage = "http://jruby.org/";
    license = with licenses; [ cpl10 gpl2 lgpl21 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.fzakaria ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
};
in jruby.overrideAttrs (oldAttrs: {
  passthru = oldAttrs.passthru // {
    devEnv = callPackage ../ruby/dev.nix {
      ruby = jruby;
    };
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
})
