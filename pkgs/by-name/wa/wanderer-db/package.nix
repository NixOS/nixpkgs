{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wanderer-db";
  version = "0.20.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "open-wanderer";
    repo = "wanderer";
    rev = "v${version}";
    hash = "sha256-Z4oKOf8bLyoYqjsg/bWWc8GYai2ZUYISFBiu4AHGexY=";
  };

  sourceRoot = "${src.name}/db";

  proxyVendor = true;
  vendorHash = "sha256-WaG+bc9QxgffJGHOaSz0S7/bXDMu57Drvqa7Qk0WMSY=";

  postInstall = ''
    if [ -f $out/bin/pocketbase ]; then
      mv $out/bin/pocketbase $out/bin/wanderer-db
    fi
  '';

  meta = {
    description = "PocketBase database backend for Wanderer trail database";
    homepage = "https://github.com/open-wanderer/wanderer";
    license = lib.licenses.agpl3Only;
    mainProgram = "wanderer-db";
    maintainers = with lib.maintainers; [ maartenbehn ];
    platforms = lib.platforms.unix;
  };
}
