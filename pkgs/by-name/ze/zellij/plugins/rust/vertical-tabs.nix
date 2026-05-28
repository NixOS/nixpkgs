{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-vertical-tabs";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "cfal";
    repo = "zellij-vertical-tabs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0+Ye7IUtGjOqCtzCkZZgwUkYaFFX+74HBZwtRdY4sH4=";
  };

  cargoHash = "sha256-m9so6yv9lHBjAJGM4u+S+Tzh06aCAjN+Db2caV+1QA4=";

  meta = {
    description = "Display tabs vertically on the left or right side of the screen";
    homepage = "https://github.com/cfal/zellij-vertical-tabs";
    license = lib.licenses.mit;
  };
})
