{ buildDhallGitHubPackage, Prelude }:

buildDhallGitHubPackage {
  name = "grafana";
  owner = "weeezes";
  repo = "dhall-grafana";
  # 2022-07-10
  rev = "49a3ee4801cf64f479e3f0bad839a5dd8e5b4932";
  sha256 = "1i8b98xx20b73afkmr78l4x4ci3dk2sc737hxkcaxp3sgncwnz1b";
  dependencies = [ Prelude ];
}
