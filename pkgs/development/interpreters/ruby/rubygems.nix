args : with args; 

rec {
  name = "rubygems-" + version;
  version = "2.4.8";
  src = fetchurl {
    url = "http://production.cf.rubygems.org/rubygems/${name}.tgz";
    sha256 = "0pl4civyf0vhqsqbqaivvxrb3fsg8sid9a8jv5vfnk4hypz3ahss";
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
    EOF'') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

  /* doConfigure should be specified separately */
  phaseNames = ["doPatch" "doInstall"];
      
  meta = {
    description = "Ruby gems package collection";
    longDescription = ''
      Nix can create nix packages from gems.

      To use it by installing gem-nix package.
    '';
  };

  patches = [ ./gem_hook.patch ];
}
