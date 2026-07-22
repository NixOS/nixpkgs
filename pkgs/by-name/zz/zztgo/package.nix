{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
}:

buildGoModule {
  pname = "zztgo";
  version = "0-unstable-2020-05-29";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "zztgo";
    rev = "9edb1452d887852c5c68cae0a91a6227cd4ef7a9";
    hash = "sha256-Wz9xAcsT27scuR78X6+17l0RExpmh0uTQUOcQ9lHIkI=";
  };

  vendorHash = "sha256-0hOXo7Ww34yI5yrz4CDMuFZjPj9CqtmWxQoc9aEBFOs=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -Dm644 TOWN.ZZT $out/share/zztgo/TOWN.ZZT
    install -Dm644 zzt.terminal $out/share/zztgo/zzt.terminal

    wrapProgram $out/bin/zztgo \
      --chdir $out/share/zztgo
  '';

  meta = {
    description = "Port of ZZT to Go";
    homepage = "https://github.com/benhoyt/zztgo";
    mainProgram = "zztgo";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
}
