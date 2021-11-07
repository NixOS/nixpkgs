{ dhallPackages, buildDhallGitHubPackage }:

buildDhallGitHubPackage {
  name = "grafana";
  owner = "weeezes";
  repo = "dhall-grafana";
  # 2021-11-06
  rev = "9ee0bb643f01db6d9935cf7df1914c32a92730b4";
  sha256 = "0a123r5a33p8kaqs68rx2ycjr72xvxcpcmvpqxgb2jb05mnjj540";
  dependencies = [ dhallPackages.Prelude ];
}
