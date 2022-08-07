{ lib, stdenv, callPackage, fetchurl, makeWrapper, jre }:

let
# The version number here is whatever is reported by the RUBY_VERSION string
rubyVersion = callPackage ../ruby/ruby-version.nix {} "2" "5" "7" "";
jruby = stdenv.mkDerivation rec {
  pname = "jruby";

  version = "9.3.6.0";

  src = fetchurl {
    url = "https://s3.amazonaws.com/jruby.org/downloads/${version}/jruby-bin-${version}.tar.gz";
    sha256 = "sha256-dHr2r5mmdPII9A2o2yLXfG2kk6gygOmQtS1SOr2UmeI=";
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
    devEnv = callPackage ../ruby/dev.nix {
      ruby = jruby;
    };
  };
})
