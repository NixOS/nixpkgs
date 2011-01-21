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
    wrapProgram $out/bin/gem --prefix RUBYLIB : $out/lib
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
      Nix can create nix packages from gems.

      To use it do the following:
      1. Install rubygems and rubyLibs.nix.
      2. Add $your_profile/${ruby.gemPath} to GEM_PATH.
      3. export RUBYLIB=$your_profile/lib RUBYOPT=rubygems
      4. See `gem nix --help` for the rest.
    '';
  };

  patches = [ ./gem_hook.patch ];
}
