{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  webkitgtk_6_0,
}:

buildGoModule (finalAttrs: {
  pname = "wails3";
  version = "3.0.0-alpha.102";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wailsapp";
    repo = "wails";
    tag = "v${finalAttrs.version}";
    hash = "sha256-os19NyyBhyVpPgUDkHLWIkd8u8b6747MiGKlVV4p2Es=";
  };

  proxyVendor = true;
  vendorHash = "sha256-SEcH4p1EnkJlbNb0wLBBJWXndbPjBfXSUk6xWUAQgXM=";

  subPackages = [ "v3/cmd/wails3" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ webkitgtk_6_0 ];

  # Abuse propagation math a little bit, so when nativeBuildInputs = [ wails3 ],
  # we also get nativeBuildInputs = [ pkg-config wrapGAppsHook4 ], buildInputs = [ webkitgtk_6_0 ].
  propagatedBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  depsTargetTargetPropagated = [ webkitgtk_6_0 ];

  meta = {
    description = "Build desktop applications using Go & Web Technologies, v3 alpha";
    homepage = "https://wails.io";
    license = lib.licenses.mit;
    mainProgram = "wails3";
    platforms = lib.platforms.unix;
  };
})
