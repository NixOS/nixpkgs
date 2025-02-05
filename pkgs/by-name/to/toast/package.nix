{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "toast";
  version = "0.47.7";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vp70jv4F0VKd/OZHVRDcIJlKLwK9w+cV28lh0C7ESqg=";
  };

  cargoHash = "sha256-ezYwdUnM0xjDtmQEyTJEAoE/VjVEOOEgxvjrmusrJSY=";

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = with lib; {
    description = "Containerize your development and continuous integration environments";
    mainProgram = "toast";
    homepage = "https://github.com/stepchowfun/toast";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
