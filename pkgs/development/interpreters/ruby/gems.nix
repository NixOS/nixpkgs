args : with args; 
rec {

  # some packages (eg ruby-debug) still require 1.8. So let's stick to that for
  # now if nobody has different requirements

  version = "1.4.1";
  src = fetchurl {
    url = "http://production.cf.rubygems.org/rubygems/${name}.tgz";
    sha256 = "189wg1msb4sdjvdzv9ia6q3lvjlygpp67wlbkl7cjb22bpjy4w4b";
  };


  buildInputs = [ruby makeWrapper];
  configureFlags = [];

  doInstall = fullDepEntry (''
    ruby setup.rb --prefix=$out/
    wrapProgram $out/bin/gem --prefix RUBYLIB : $out/lib:$out/lib
    find $out -type f -name "*.rb" | xargs sed -i "s@/usr/bin/env@$(type -p env)@g"
    mkdir -pv $out/nix-support
    cat > $out/nix-support/setup-hook <<EOF
    export RUBYOPT=rubygems
    addToSearchPath RUBYLIB $out/lib

    addGemPath() {
      addToSearchPath GEM_PATH \$1/${ruby.gemPath}
    }

    envHooks+=(addGemPath)
    EOF'') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

  /* doConfigure should be specified separately */
  phaseNames = ["doPatch" "doInstall"];
      
  name = "rubygems-" + version;
  meta = {
    description = "Ruby gems package collection";
    longDescription = ''
      see comment in rubyLibs to get to know how to use ruby gems in nix
    '';
  };

  # TODO don't resolve 302 redirects but make nix resolve in fetchurl and
  # nix-prefetch-url. This should be done on stdenv-updates.
  patches = [ ./gem_nix_command.patch /* see longDescription above */ ];
}
