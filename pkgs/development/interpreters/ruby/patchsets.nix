{ patchSet, version }:

let
  directory = "${patchSet}/patches/ruby/${version}/head/railsexpress";
  files = builtins.attrNames (builtins.readDir directory);
  patches = map (file: "${directory}/${file}") files;
in
  patches
