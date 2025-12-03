{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  easytier,
  replaceVars,
  imagemagick,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terracotta";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "burningtnt";
    repo = "Terracotta";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zp3Ax0A7Vc6LnZiWu2pWzQTWvYH9NRmqSfmxK756qA8=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      echo $(git log -1 --pretty=%ct)"000" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  patches = [
    # For reproducibility
    ./0001-nix-read-timestamp-from-SOURCE_DATE_EPOCH.patch
    # Use easytier from inputs instead
    (replaceVars ./0002-nix-use-easytier-from-nix-input.patch {
      TERRACOTTA_ET_PATH = easytier;
      TERRACOTTA_ET_EXE = "${easytier}/bin/easytier-core";
      TERRACOTTA_ET_CLI = "${easytier}/bin/easytier-cli";
    })
  ];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    daemon_plist="$out/Library/LaunchAgents/org.nixos.terracotta.daemon.plist"
    substituteInPlace src/main.rs \
      --replace-fail '/Library/LaunchAgents/net.burningtnt.terracotta.daemon.plist' "$daemon_plist"
  '';

  nativeBuildInputs = [ imagemagick ];

  cargoLock.lockFile = ./Cargo.lock;

  env = {
    # terracotta depends on nightly features
    RUSTC_BOOTSTRAP = 1;
    TERRACOTTA_ET_VERSION = "v${easytier.version}";
    TERRACOTTA_VERSION = finalAttrs.version;
  };

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm0644 build/linux/terracotta.desktop -t $out/share/applications

      for n in 16 32 48 64 96 128 256
      do
        size=$n"x"$n
        mkdir -p $out/share/icons/hicolor/$size/apps
        magick build/linux/icon.png -resize $size $out/share/icons/hicolor/$size/apps/terracotta.png
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/{Library/LaunchAgents,Applications}

      cp -r build/macos/terracotta.app $out/Applications/
      ln -sr $out/bin/terracotta $out/Applications/terracotta.app/Contents/MacOS/terracotta

      cat > "$daemon_plist" <<EOF
      ${lib.generators.toPlist { escape = true; } {
        Label = "org.nixos.terracotta.daemon";
        ProgramArguments = [
          "@TERRACOTTA_BIN@"
          "--daemon"
        ];
        KeepAlive = true;
      }}
      EOF
      substituteInPlace "$daemon_plist" \
        --replace-fail '@TERRACOTTA_BIN@' "$out/bin/terracotta"
    '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "Terracotta provides out-of-the-box multiplayer support for Minecraft";
    homepage = "https://github.com/burningtnt/Terracotta";
    changelog = "https://github.com/burningtnt/Terracotta/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "terracotta";
  };
})
