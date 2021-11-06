{ dhallPackages, buildDhallGitHubPackage }:

buildDhallGitHubPackage {
  name = "grafana";
  owner = "weeezes";
  repo = "dhall-grafana";
  # 2021-11-05
  rev = "bf2f8c8ab44682c8cef4fdce2d2f7fbeb0cfe162";
  sha256 = "0h1l39kj49yvadpbw6jw3mc7qzsmhxlqqpx3cgnr9f063nh73f96";
  dependencies = [ dhallPackages.Prelude ];
}
