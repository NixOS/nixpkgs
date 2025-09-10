{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  go,
  nodejs,
  zlib,
  nix-update-script,
  # Linux specific dependencies
  gtk3,
  webkitgtk_4_1,
}:

buildGoModule rec {
  pname = "wails";
  version = "2.10.2";

  src =
    fetchFromGitHub {
      owner = "wailsapp";
      repo = "wails";
      tag = "v${version}";
      hash = "sha256-b0ns2cXlUT5tPbVEOzQGftxoUqGEDuzj+2KDxNnfs4c=";
    }
    + "/v2";

  vendorHash = "sha256-u1NoAHxBSzw44W3l5MzMxMUjgrfM9EDkKwR4GAPQBVE=";

  proxyVendor = true;

  subPackages = [ "cmd/wails" ];

  # These packages are needed to build wails
  # and will also need to be used when building a wails app.
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # Wails apps are built with Go, so we need to be able to
  # add it in propagatedBuildInputs.
  allowGoReference = true;

  # Following packages are required when wails used as a builder.
  propagatedBuildInputs = [
    pkg-config
    go
    stdenv.cc
    nodejs
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    webkitgtk_4_1
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  # As Wails calls a compiler, certain apps and libraries need to be made available.
  postFixup = ''
    wrapProgram $out/bin/wails \
      --prefix PATH : ${
        lib.makeBinPath [
          pkg-config
          go
          stdenv.cc
          nodejs
        ]
      } \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath (
          lib.optionals stdenv.hostPlatform.isLinux [
            gtk3
            webkitgtk_4_1
          ]
        )
      }" \
      --set PKG_CONFIG_PATH "$PKG_CONFIG_PATH" \
      --set CGO_LDFLAGS "-L${lib.makeLibraryPath [ zlib ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Build desktop applications using Go & Web Technologies";
    homepage = "https://wails.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thtrf ];
    mainProgram = "wails";
    platforms = lib.platforms.unix;
  };
}
