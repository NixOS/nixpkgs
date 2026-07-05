{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkgsBuildBuild,

  go,
  darwin,
  nixosTests,

  nix-update-script,

  target ? "syncthing",
}:

assert builtins.elem target [
  "syncthing"
  "stdiscosrv" # syncthing-discovery
  "strelaysrv" # syncthing-relay
];

buildGoModule (finalAttrs: {
  pname = "syncthing";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sTtFmZBPJIHMksaFFLmA3Abt9EhAC8Nz/ibdzg2LMd4=";
  };

  vendorHash = "sha256-rOsdg98WVAKqjV7AxH+m4oSf8Z4FPru4NSbgGFtUMVE=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    # Recent versions of macOS seem to require binaries to be signed when
    # run from Launch Agents/Daemons, even on x86 devices where it has a
    # more lax code signing policy compared to Apple Silicon. So just sign
    # the binaries on both architectures to make it possible for launchd to
    # auto-start Syncthing at login.
    darwin.autoSignDarwinBinariesHook
  ];

  doCheck = false;

  env = {
    BUILD_USER = "nix";
    BUILD_HOST = "nix";
  };

  buildPhase = ''
    runHook preBuild
    (
      export GOOS="${pkgsBuildBuild.go.GOOS}" GOARCH="${pkgsBuildBuild.go.GOARCH}" CC=$CC_FOR_BUILD
      go build build.go
      go generate github.com/syncthing/syncthing/lib/api/auto github.com/syncthing/syncthing/cmd/infra/strelaypoolsrv/auto
    )
    ./build -goos ${go.GOOS} -goarch ${go.GOARCH} -no-upgrade -version v${finalAttrs.version} build ${target}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 ${target} $out/bin/${target}
    runHook postInstall
  '';

  postInstall = ''
    # This installs man pages in the correct directory according to the suffix
    # on the filename
    for mf in man/*.[1-9]; do
      mantype="$(echo "$mf" | awk -F"." '{print $NF}')"
      mandir="$out/share/man/man$mantype"
      install -Dm644 "$mf" "$mandir/$(basename "$mf")"
    done

    install -Dm644 etc/linux-desktop/syncthing-ui.desktop $out/share/applications/syncthing-ui.desktop
    install -Dm644 assets/logo-32.png   $out/share/icons/hicolor/32x32/apps/syncthing.png
    install -Dm644 assets/logo-64.png   $out/share/icons/hicolor/64x64/apps/syncthing.png
    install -Dm644 assets/logo-128.png  $out/share/icons/hicolor/128x128/apps/syncthing.png
    install -Dm644 assets/logo-256.png  $out/share/icons/hicolor/256x256/apps/syncthing.png
    install -Dm644 assets/logo-512.png  $out/share/icons/hicolor/512x512/apps/syncthing.png
    install -Dm644 assets/logo-only.svg $out/share/icons/hicolor/scalable/apps/syncthing.svg

  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux) ''
    mkdir -p $out/lib/systemd/{system,user}

    substitute etc/linux-systemd/system/syncthing@.service \
               $out/lib/systemd/system/syncthing@.service \
               --replace-fail /usr/bin/syncthing $out/bin/syncthing

    substitute etc/linux-systemd/user/syncthing.service \
               $out/lib/systemd/user/syncthing.service \
               --replace-fail /usr/bin/syncthing $out/bin/syncthing
  '';

  passthru = {
    tests = {
      inherit (nixosTests)
        syncthing
        syncthing-folders
        syncthing-guiPassword
        syncthing-guiPasswordFile
        syncthing-init
        syncthing-no-settings
        syncthing-relay
        ;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://syncthing.net/";
    description = "Open Source Continuous File Synchronization";
    donationPage = "https://syncthing.net/donations/";
    changelog = "https://github.com/syncthing/syncthing/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      joko
      peterhoeg
      zainkergaye
    ];
    mainProgram = target;
    platforms = lib.platforms.unix;
  };
})
