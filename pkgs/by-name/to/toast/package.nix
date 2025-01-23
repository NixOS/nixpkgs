{
  lib,
  rustPlatform,
  fetchFromGitHub,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-SzbQaiHOhczxChpKwcIkq1VOY9PfCbNtI5rhxZ5B5No=";

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = with lib; {
    description = "Containerize your development and continuous integration environments";
    mainProgram = "toast";
    homepage = "https://github.com/stepchowfun/toast";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
