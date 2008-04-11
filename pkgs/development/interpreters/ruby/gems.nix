args : with args; 
rec {
  src = fetchurl {
    url = http://rubyforge.org/frs/download.php/35283/rubygems-1.1.1.tgz;
    sha256 = "1qb4crmx1dihmk1am93ly437480jvp7lh4pbiwy5ir19hqnfh71b";
  };
  version = "1.1.1";

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
    description = "Ruby package collection";
  };
}
