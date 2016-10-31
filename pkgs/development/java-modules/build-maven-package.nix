{ stdenv, maven, pkgs }:
{ mavenDeps, src, name, meta, m2Path, ... }:

with builtins;
with stdenv.lib;

let
  mavenMinimal = import ./maven-minimal.nix { inherit pkgs stdenv maven; };
in stdenv.mkDerivation rec {
  inherit mavenDeps src name meta m2Path;

  flatDeps = unique (flatten (mavenDeps ++ mavenMinimal.mavenMinimal));

  propagatedBuildInput = [ maven ] ++ flatDeps;

  find = ''find ${foldl' (x: y: x + " " + y) "" (map (x: x + "/m2/") flatDeps)} -type d -printf '%P\n' | xargs -I {} mkdir -p $out/m2/{}'';
  copy = ''cp -rs ${foldl' (x: y: x + " " + y) "" (map (x: x + "/m2/*") flatDeps)} $out/m2'';

  phases = [ "unpackPhase" "buildPhase" ];

  buildPhase = ''
    mkdir -p $out/target
    mkdir -p $out/m2/${m2Path}
    ${optionalString (length flatDeps > 0) find}
    ${optionalString (length flatDeps > 0) copy}
    echo "<settings><mirrors>\
        <mirror><id>tmpm2</id><url>file://$out/m2</url><mirrorOf>*</mirrorOf></mirror></mirrors>\
        <localRepository>$out/m2</localRepository></settings>" >> $out/m2/settings.xml
    ${maven}/bin/mvn clean install -Dmaven.test.skip=true -gs $out/m2/settings.xml
    cp -v ./target/*.jar $out/target/
  '';
}
