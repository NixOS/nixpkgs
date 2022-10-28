{ version, fetchFromGitHub }:

let
  patchSet = fetchFromGitHub {
    owner  = "skaes";
    repo   = "rvm-patchsets";
    rev    = "a6429bb1a7fb9b5798c22f43338739a6c192b42d";
    sha256 = "sha256-NpSa+uGQA1rfHNcLzPNTK65J+Wk9ZlzhHFePDA4uuo0=";
  };
  directory = "${patchSet}/patches/ruby/${version}/head/railsexpress";
  files = builtins.attrNames (builtins.readDir directory);
  patches = map (file: "${directory}/${file}") files;
in
  patches
