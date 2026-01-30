{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "compress.yazi";
  version = "25.12.29-unstable-2026-01-24";

  src = fetchFromGitHub {
    owner = "KKV9";
    repo = "compress.yazi";
    rev = "cb6e8ec0141915dc319ccd6b904dcd2f03502576";
    hash = "sha256-D/EpcRDIc3toeyjHqi+vGw0v9B22HVvKJua5EVEAc0U=";
  };

  meta = {
    description = "Yazi plugin that compresses selected files to an archive";
    homepage = "https://github.com/KKV9/compress.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
