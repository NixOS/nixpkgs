args : with args; 
rec {

  version = "1.8.17";
  src = fetchurl {
    url = "http://production.cf.rubygems.org/rubygems/${name}.tgz";
    sha256 = "068sr55r8wiw55bpf93pp07871cbqhxk9cxma6arhd04j7n8ppph";
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
      3. export RUBYLIB=$your_profile/lib RUBYOPT=rubygems.
      4. Run `gem nix --[no-]user-install gem1 gem2 ...` to generate Nix
      expression from gem repository.
      5. Install rubyLibs.gem1 etc.
    '';
  };

  patches = [ ./gem_hook.patch ];
}
