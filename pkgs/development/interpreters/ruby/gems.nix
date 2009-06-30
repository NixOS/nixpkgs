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
      see comment in rubyLibs to get to know how to use ruby gems in nix
    '';
  };

  # TODO don't resolve 302 redirects but make nix resolve in fetchurl and
  # nix-prefetch-url. This should be done on stdenv-updates.
  patches = [ ./gem_nix_command.patch /* see longDescription above */ ];
}
