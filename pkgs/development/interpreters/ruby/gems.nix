args : with args; 
rec {
  version = "1.2.0";
  src = fetchurl {
    url = "http://rubyforge.org/frs/download.php/38646/rubygems-${version}.tgz";
    sha256 = "0b9ppgs9av4z344s13wp40ki72prxyz3q0hmsf5swx7xhl54bbr8";
  };

  buildInputs = [ruby makeWrapper];
  configureFlags = [];

  doInstall = FullDepEntry (''
    ruby setup.rb --prefix=$out/
    wrapProgram $out/bin/gem --prefix RUBYLIB : $out/lib:$out/lib
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];

  /* doConfigure should be specified separately */
  phaseNames = ["doInstall"];
      
  name = "rubygems-" + version;
  meta = {
    description = "Ruby gems package collection";
  };
}
