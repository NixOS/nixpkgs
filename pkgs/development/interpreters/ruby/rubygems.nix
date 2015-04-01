args : with args; 

rec {
  name = "rubygems-" + version;
  version = "2.4.1";
  src = fetchurl {
    url = "http://production.cf.rubygems.org/rubygems/${name}.tgz";
    sha256 = "0cpr6cx3h74ykpb0cp4p4xg7a8j0bhz3sk271jq69l4mm4zy4h4f";
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
