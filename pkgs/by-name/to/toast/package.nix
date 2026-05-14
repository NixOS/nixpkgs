{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "toast";
  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "toast";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bhKIJ1x4WQAPAMEyw12NmmDbnDYbucIz0U3/MdTfmP0=";
  };

  cargoHash = "sha256-zo+KTtCJkCjG9j/VgUcnTZfRyJLj0C3BvKRREAjyeb8=";

  checkFlags = [ "--skip=format::tests::code_str_display" ]; # fails

  meta = {
    description = "Containerize your development and continuous integration environments";
    mainProgram = "toast";
    homepage = "https://github.com/stepchowfun/toast";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
