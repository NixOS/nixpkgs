{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tango";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "masakichi";
    repo = "tango";
    rev = "v${finalAttrs.version}";
    hash = "sha256-e/M2iRm/UwfnRVnMo1PmQTkz4IGTxnsCXNSSUkhsiHk=";
  };

  vendorHash = "sha256-83nKtiEy1na1HgAQcbTEfl+0vGg6BkCLBK1REN9fP+k=";

  meta = {
    description = "Local command-line Japanese dictionary tool using yomichan's dictionary files";
    homepage = "https://github.com/masakichi/tango";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "tango";
  };
})
