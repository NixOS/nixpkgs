{ lib, stdenv, callPackage, fetchurl, makeBinaryWrapper, jre }:

let
# The version number here is whatever is reported by the RUBY_VERSION string
rubyVersion = callPackage ../ruby/ruby-version.nix {} "3" "1" "4" "";
jruby = stdenv.mkDerivation rec {
  pname = "jruby";

  version = "9.4.3.0";

  src = fetchurl {
    url = "https://s3.amazonaws.com/jruby.org/downloads/${version}/jruby-bin-${version}.tar.gz";
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
    homepage = "https://www.jruby.org/";
    changelog = "https://github.com/jruby/jruby/releases/tag/${version}";
    license = with licenses; [ cpl10 gpl2 lgpl21 ];
    platforms = jre.meta.platforms;
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
})
