{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_net,
  SDL2_ttf,
  pango,
  gettext,
  boost186,
  libvorbis,
  fribidi,
  dbus,
  libpng,
  pcre,
  openssl,
  icu,
  lua5_4,
  curl,
  nix-update-script,
}:

let
  boost = boost186;
  # wesnoth requires lua built with c++, see https://github.com/wesnoth/wesnoth/pull/8234
  lua = lua5_4.override {
    postConfigure = ''
      makeFlagsArray+=("CC=$CXX")
    '';
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wesnoth";
  version = "1.18.5";

  src = fetchFromGitHub {
    owner = "wesnoth";
    repo = "wesnoth";
    tag = finalAttrs.version;
    hash = "sha256-0VZJAmaCg12x4S07H1kl5s2NGMEo/NSVnzMniREmPJk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    pango
    gettext
    boost
    libvorbis
    fribidi
    dbus
    libpng
    pcre
    openssl
    icu
    lua
    curl
  ];

  cmakeFlags = [
    "-DENABLE_SYSTEM_LUA=ON"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    app_name="The Battle for Wesnoth"
    app_bundle="$out/Applications/$app_name.app"
    app_contents="$app_bundle/Contents"
    mkdir -p "$app_contents"
    echo "APPL????" > "$app_contents/PkgInfo"
    mv $out/bin "$app_contents/MacOS"
    mv $out/share/wesnoth "$app_contents/Resources"
    pushd ../projectfiles/Xcode
    substitute Info.plist "$app_contents/Info.plist" \
      --replace-fail ''\'''${EXECUTABLE_NAME}' wesnoth \
      --replace-fail '$(PRODUCT_BUNDLE_IDENTIFIER)' org.wesnoth.Wesnoth \
      --replace-fail ''\'''${PRODUCT_NAME}' "$app_name"
    cp -r Resources/SDLMain.nib "$app_contents/Resources/"
    install -m0644 Resources/{container-migration.plist,icon.icns} "$app_contents/Resources"
    popd

    # Make the game and dedicated server binary available for shell users
    mkdir -p "$out/bin"
    ln -s "$app_contents/MacOS/wesnothd" "$out/bin/wesnothd"
    # Symlinking the game binary is unsifficient as it would be unable to
    # find the bundle resources
    cat << EOF > "$out/bin/wesnoth"
    #!${stdenvNoCC.shell}
    open -na "$app_bundle" --args "\$@"
    EOF
    chmod +x "$out/bin/wesnoth"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      # the minor release number also denotes if this is a beta release:
      # even is stable, odd is beta
      "^(\\d+\\.\\d*[02468]\\.\\d+)$"
    ];
  };

  meta = {
    description = "Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
    longDescription = ''
      The Battle for Wesnoth is a Free, turn-based tactical strategy
      game with a high fantasy theme, featuring both single-player, and
      online/hotseat multiplayer combat. Fight a desperate battle to
      reclaim the throne of Wesnoth, or take hand in any number of other
      adventures.
    '';

    homepage = "https://www.wesnoth.org/";
    changelog = "https://github.com/wesnoth/wesnoth/blob/${finalAttrs.version}/changelog.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      niklaskorz
      iedame
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wesnoth";
  };
})
