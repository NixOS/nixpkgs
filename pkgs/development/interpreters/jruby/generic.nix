{ stdenv,
  callPackage,
  fetchurl,
  makeWrapper,
  jre,
  version,
  sha256,
  # The version number here is whatever is reported by the RUBY_VERSION string
  rubyVersion}:
let self = stdenv.mkDerivation rec {
  inherit version;

  pname = "jruby";

  src = fetchurl {
    url = "https://s3.amazonaws.com/jruby.org/downloads/${version}/jruby-bin-${version}.tar.gz";
    sha256 = sha256;
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
     mkdir -pv $out/docs
     mv * $out
     rm $out/bin/*.{bat,dll,exe,sh}
     mv $out/COPYING $out/LICENSE* $out/docs

     for i in $out/bin/jruby{,.bash}; do
       wrapProgram $i \
         --set JAVA_HOME ${jre}
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

  passthru = rec {
    rubyEngine = "jruby";
    gemPath = "lib/${rubyEngine}/gems/${rubyVersion.libDir}";
    libPath = "lib/${rubyEngine}/${rubyVersion.libDir}";
    devEnv = callPackage ../ruby/dev.nix {
      ruby = self;
    };
  };

  meta = with stdenv.lib; {
    description = "Ruby interpreter written in Java";
    homepage = "http://jruby.org/";
    license = with licenses; [ cpl10 gpl2 lgpl21 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.fzakaria ];
  };
};
in self
