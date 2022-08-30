{ runCommand, dconf }:

{
  # Builds a dconf database from a keyfile directory
  mkDconfDb = dir: runCommand "dconf-db" {
    nativeBuildInputs = [ dconf ];
  } ''
    dconf compile $out ${dir}
  '';
}
