args : with args; 
rec {

  # some packages (eg ruby-debug) still require 1.8. So let's stick to that for
  # now if nobody has different requirements

  version = "1.3.4";
  src = fetchurl {
    url = "http://rubyforge.org/frs/download.php/57643/rubygems-1.3.4.tgz";
    sha256 = "1z5vvwdf7cwiq669amfxzqd88bn576yq6d9c5c6c92fm9sib1d0y";
  };

  buildInputs = [ruby makeWrapper];
  configureFlags = [];

  doInstall = fullDepEntry (''
    ruby setup.rb --prefix=$out/
    wrapProgram $out/bin/gem --prefix RUBYLIB : $out/lib:$out/lib
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

  /* doConfigure should be specified separately */
  phaseNames = ["doInstall"];
      
  name = "rubygems-" + version;
  meta = {
    description = "Ruby gems package collection";
    longDescription = ''
      Example usage:
      export GEM_HOME=~/.gem_home
      export RUBYLIB=~/.nix-profile/lib
      gem install -i .ruby-gems json
      ruby -I ~/.ruby-gems/gems/json-1.1.3/lib your-script.rb
      Probably there are better ways to handle this all. Go on and fix it.
    '';
  };
}
