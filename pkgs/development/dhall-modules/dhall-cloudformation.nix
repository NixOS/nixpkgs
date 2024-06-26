{ buildDhallGitHubPackage, Prelude }:

let
  version = "0.9.64";

in
buildDhallGitHubPackage {
  name = "cloudformation";
  owner = "jcouyang";
  repo = "dhall-aws-cloudformation";
  rev = version;
  sha256 = "sha256-EDbMKHORYQOKoSrbErkUnsadDiYfK1ULbFhz3D5AcXc=";
  file = "package.dhall";
  dependencies = [ Prelude ];
}
