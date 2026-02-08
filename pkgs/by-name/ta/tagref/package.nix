{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tagref";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "tagref";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ANQxW5Qznu2JbiazFElB1sxpX4BwPgk6SVGgYpJ6DUw=";
  };

  cargoHash = "sha256-XQ0/J8o9yqEGWH1Cy5VDkpsK60SS6JhYxMNsI08uI6U=";

  meta = {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.yusdacra ];
    platforms = lib.platforms.unix;
    mainProgram = "tagref";
  };
})
