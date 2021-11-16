{ dhallPackages, buildDhallGitHubPackage }:

buildDhallGitHubPackage {
  name = "grafana";
  owner = "weeezes";
  repo = "dhall-grafana";
  # 2021-11-12
  rev = "d5630dc55deacf5100a99802a4df1d9680b263b3";
  sha256 = "01320hpqgr5r4grsydmdl9yznmly1ssnlc9gcwa8rj1ah0a8xlgz";
  dependencies = [ dhallPackages.Prelude ];
}
