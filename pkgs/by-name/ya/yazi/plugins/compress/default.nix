{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "compress.yazi";
  version = "0-unstable-2026-01-03";

  src = fetchFromGitHub {
    owner = "KKV9";
    repo = "compress.yazi";
    rev = "f9208fe6c1885ff4fe9bcc890e4c96d87d91d37d";
    hash = "sha256-teyZP1ij/T92fJx8gf9Z8/ddzcNknNC6KijaYeAzPz8=";
  };

  meta = {
    description = "Yazi plugin that compresses selected files to an archive";
    homepage = "https://github.com/KKV9/compress.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
