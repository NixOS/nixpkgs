{ stdenv, maven }:
{ mavenDeps, src, name, meta, m2Path }:


stdenv.mkDerivation rec {
  inherit mavenDeps src name meta m2Path;

  propagatedBuildInput = [ maven ] ++ mavenDeps;

  find = if (builtins.length mavenDeps > 0) then ''find ${builtins.foldl' (x: y: x + " " + y) "" (map (x: x + "/m2/") mavenDeps)} -type d -printf '%P\n' | xargs -I {} mkdir -vp $out/m2/{}'' else "";
  copy = if (builtins.length mavenDeps > 0) then ''cp -rs ${builtins.foldl' (x: y: x + " " + y) "" (map (x: x + "/m2/*") mavenDeps)} $out/m2'' else "";

  buildPhase = ''
    mkdir -p $out/m2/${m2Path}
    ${find}
    ${copy}
    echo "<settings><mirrors>\
    	<mirror><id>tmpm2</id><url>file://$out/m2</url><mirrorOf>*</mirrorOf></mirror></mirrors>\
    	<localRepository>$out/m2</localRepository></settings>" >> $out/m2/settings.xml
    ${maven}/bin/mvn clean install -X -Dmaven.test.skip=true -gs $out/m2/settings.xml
  '';
}
