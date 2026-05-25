{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tenki";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "tenki";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jd7D0iC3+s3w6uG0WqlvL9F4xQL+cQzsUvAIOc7ORgw=";
  };

  cargoHash = "sha256-jV+KHHAPpsFxNnBaMPE5XYDG4Fhn3a89NBUpZg++YUE=";

  meta = {
    description = "tty-clock with weather effect";
    homepage = "https://github.com/ckaznable/tenki";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "tenki";
  };
})
