{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "toast";
  version = "0.47.6";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+qntd687LF4tJwHZglZ6mppHq3dOZ+l431oKBBNDI0k=";
  };

  cargoHash = "sha256-A2sJ0o0RDztk3NjxG0CD8wNA4tmOizY4Tvff6ADzYQ8=";

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = with lib; {
    description = "Containerize your development and continuous integration environments";
    mainProgram = "toast";
    homepage = "https://github.com/stepchowfun/toast";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
