{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "tagref";
    rev = "v${version}";
    sha256 = "sha256-ANQxW5Qznu2JbiazFElB1sxpX4BwPgk6SVGgYpJ6DUw=";
  };

  cargoHash = "sha256-XQ0/J8o9yqEGWH1Cy5VDkpsK60SS6JhYxMNsI08uI6U=";

  meta = with lib; {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
    mainProgram = "tagref";
  };
}
