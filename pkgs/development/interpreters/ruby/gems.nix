args : with args; 
rec {

  # some packages (eg ruby-debug) still require 1.8. So let's stick to that for
  # now if nobody has different requirements

  version = "1.3.7";
  src = fetchurl {
    url = "http://production.cf.rubygems.org/rubygems/${name}.tgz";
    sha256 = "17bwlqxqrjrial111rn395yjx9wyxrmvmj0hgd85bxkkcap912rq";
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
