{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "synth";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "shuttle-hq";
    repo = "synth";
    rev = "v${version}";
    sha256 = "sha256-/z2VEfeCCuffxlMh4WOpYkMSAgmh+sbx3ajcD5d4DdE=";
  };

  cargoHash = "sha256-sJSU85f4bLh89qo8fojWJNfJ9t7i/Hlg5pnLcxcwKt4=";

  checkFlags = [
    # https://github.com/shuttle-hq/synth/issues/309
    "--skip=docs_blog_2021_08_31_seeding_databases_tutorial_dot_md"
  ];

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "Tool for generating realistic data using a declarative data model";
    homepage = "https://github.com/getsynth/synth";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
