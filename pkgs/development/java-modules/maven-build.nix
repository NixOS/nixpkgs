{ stdenv, maven }:
{ mavenDeps, src, name, meta, m2Path }:


stdenv.mkDerivation rec {
  inherit mavenDeps src name meta m2Path;

  propagatedBuildInput = [ maven ] ++ mavenDeps;

  buildPhase = ''
    mkdir -p $out/m2/${m2Path}
    find ${builtins.foldl' (x: y: x + " " + y) "" (map (x: x + "/m2/") mavenDeps)} -type d -printf '%P\n' | xargs -I {} mkdir -vp $out/m2/{}
    cp -rs ${builtins.foldl' (x: y: x + " " + y) "" (map (x: x + "/m2/*") mavenDeps)} $out/m2
    echo "<settings><mirrors>\
    	<mirror><id>tmpm2</id><url>file://$out/m2</url><mirrorOf>*</mirrorOf></mirror></mirrors>\
    	<localRepository>$out/m2</localRepository></settings>" >> $out/m2/settings.xml
    ${maven}/bin/mvn clean install -X -Dmaven.test.skip=true -gs $out/m2/settings.xml
  '';
}
