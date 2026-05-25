{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tz";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "oz";
    repo = "tz";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OpftKCEoAltvQw0bB3SyFeXUDiGjVHNDrrKsdRH6zl4=";
  };

  vendorHash = "sha256-Mdp2bcqTawbeqdu06QfB4atLaPpPDoE/eisTytxCnj4=";

  meta = {
    description = "Time zone helper";
    homepage = "https://github.com/oz/tz";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ siraben ];
    mainProgram = "tz";
  };
})
