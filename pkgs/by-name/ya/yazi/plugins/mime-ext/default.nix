{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mime-ext.yazi";
  version = "0-unstable-2026-09-30";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "33dde2872cee694543fe37619628a9005921c52c";
    hash = "sha256-r6a/6yNTrLcHlpPrIjNDGOf0u+ZXUUIX4QbV35Ib+jw=";
  };

  meta = {
    description = "Mime-type provider based on a file extension database, replacing the builtin file to speed up mime-type retrieval at the expense of accuracy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
