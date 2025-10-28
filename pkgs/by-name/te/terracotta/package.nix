{
  lib,
  rustPlatform,
  fetchFromGitHub,
  easytier,
  replaceVars,
  imagemagick,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terracotta";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "burningtnt";
    repo = "Terracotta";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J6tCeUwFU45xlYohp+Blv2H0gsbGrxAeWQ/bcGcmO7o=";
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
  '';

  nativeBuildInputs = [ imagemagick ];

  cargoLock.lockFile = ./Cargo.lock;

  env = {
    # terracotta depends on nightly features
    RUSTC_BOOTSTRAP = 1;
    TERRACOTTA_ET_VERSION = "v${easytier.version}";
    TERRACOTTA_VERSION = finalAttrs.version;
  };

  postInstall = ''
    install -Dm0644 build/linux/terracotta.desktop -t $out/share/applications

    for n in 16 32 48 64 96 128 256
    do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      magick build/linux/icon.png -resize $size $out/share/icons/hicolor/$size/apps/terracotta.png
    done
  '';

  meta = {
    description = "Terracotta provides out-of-the-box multiplayer support for Minecraft";
    homepage = "https://github.com/burningtnt/Terracotta";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "terracotta";
  };
})
