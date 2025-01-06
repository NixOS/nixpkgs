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
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ANQxW5Qznu2JbiazFElB1sxpX4BwPgk6SVGgYpJ6DUw=";
  };

  cargoHash = "sha256-vdmr5n4M+Qe/jzjNdg+sy7q2osTivxmLG+xMTMkEFm4=";

  meta = {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.yusdacra ];
    platforms = lib.platforms.unix;
    mainProgram = "tagref";
  };
}
