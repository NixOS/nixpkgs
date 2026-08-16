{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tut";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = "tut";
    rev = finalAttrs.version;
    sha256 = "sha256-AtwwLRZx9O8IWPFgFI/ZK0tbeshEmaKpTQxA1PepnWM=";
  };

  vendorHash = "sha256-gPF4XrUqDDJCCY1zrUr3AXDG0uoADR8LBxRP4yolcug=";

  meta = {
    description = "TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ equirosa ];
    mainProgram = "tut";
  };
})
