args : with args; 
rec {

  # some packages (eg ruby-debug) still require 1.8. So let's stick to that for
  # now if nobody has different requirements

  version = "1.3.5";
  src = fetchurl {
    url = "http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz";
    sha256 = "1b26fn9kmyd6394m1gqppi10xyf1hac85lvsynsxzpjlmv0qr4n0";
  };


  buildInputs = [ruby makeWrapper];
  configureFlags = [];

  doInstall = fullDepEntry (''
    ruby setup.rb --prefix=$out/
    wrapProgram $out/bin/gem --prefix RUBYLIB : $out/lib:$out/lib
    find $out -type f -name "*.rb" | xargs sed -i "s@/usr/bin/env@$(type -p env)@g"
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

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
