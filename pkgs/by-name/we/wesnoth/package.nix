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
  enableDevel ? false,
}:

let
  boost = boost186;
  suffix = lib.optionalString enableDevel "-devel";
  # wesnoth requires lua built with c++, see https://github.com/wesnoth/wesnoth/pull/8234
  lua = lua5_4.override {
    postConfigure = ''
      makeFlagsArray+=("CC=$CXX")
    '';
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wesnoth${suffix}";
  version = if enableDevel then "1.19.18" else "1.18.5";

  src = fetchFromGitHub {
    owner = "wesnoth";
    repo = "wesnoth";
    tag = finalAttrs.version;
    hash =
      if enableDevel then
        "sha256-BZPS60MNg9w0nf/P+vwzp2voQ5Sb1imGJIjrpJm12R0="
      else
        "sha256-0VZJAmaCg12x4S07H1kl5s2NGMEo/NSVnzMniREmPJk=";
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
    "-DBINARY_SUFFIX=${suffix}"
  ];

  postPatch = lib.optionalString (suffix != "") ''
    mv packaging/org.wesnoth.Wesnoth.desktop packaging/org.wesnoth.Wesnoth${suffix}.desktop
    mv packaging/org.wesnoth.Wesnoth.appdata.xml packaging/org.wesnoth.Wesnoth${suffix}.appdata.xml

    substituteInPlace packaging/org.wesnoth.Wesnoth${suffix}.desktop \
      --replace-fail "Name=Battle for Wesnoth" "Name=Battle for Wesnoth${suffix}" \
      --replace-fail "Exec=sh -c \"wesnoth >/dev/null 2>&1\"" "Exec=sh -c \"wesnoth${suffix} >/dev/null 2>&1\"" \
      --replace-fail "Exec=sh -c \"wesnoth -e  >/dev/null 2>&1\"" "Exec=sh -c \"wesnoth${suffix} -e  >/dev/null 2>&1\""

    substituteInPlace packaging/org.wesnoth.Wesnoth${suffix}.appdata.xml \
      --replace-fail "<name>Battle for Wesnoth</name>" "<name>Battle for Wesnoth${suffix}</name>" \
      --replace-fail "org.wesnoth.Wesnoth" "org.wesnoth.Wesnoth${suffix}" \
      --replace-fail "<binary>wesnoth</binary>" "<binary>wesnoth${suffix}</binary>" \
      --replace-fail "<binary>wesnothd</binary>" "<binary>wesnothd${suffix}</binary>"

    substituteInPlace CMakeLists.txt \
      --replace-fail "org.wesnoth.Wesnoth.desktop" "org.wesnoth.Wesnoth${suffix}.desktop" \
      --replace-fail "org.wesnoth.Wesnoth.appdata.xml" "org.wesnoth.Wesnoth${suffix}.appdata.xml"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    app_name="The Battle for Wesnoth${suffix}"
    app_bundle="$out/Applications/$app_name.app"
    app_contents="$app_bundle/Contents"
    mkdir -p "$app_contents"
    echo "APPL????" > "$app_contents/PkgInfo"
    mv $out/bin "$app_contents/MacOS"
    mv $out/share/wesnoth "$app_contents/Resources"
    pushd ../projectfiles/Xcode
    substitute Info.plist "$app_contents/Info.plist" \
      --replace-fail ''\'''${EXECUTABLE_NAME}' wesnoth${suffix} \
      --replace-fail '$(PRODUCT_BUNDLE_IDENTIFIER)' org.wesnoth.Wesnoth${suffix} \
      --replace-fail ''\'''${PRODUCT_NAME}' "$app_name"
    cp -r Resources/SDLMain.nib "$app_contents/Resources/"
    install -m0644 Resources/{container-migration.plist,icon.icns} "$app_contents/Resources"
    popd

    # Make the game and dedicated server binary available for shell users
    mkdir -p "$out/bin"
    ln -s "$app_contents/MacOS/wesnothd${suffix}" "$out/bin/wesnothd${suffix}"
    # Symlinking the game binary is unsifficient as it would be unable to
    # find the bundle resources
    cat << EOF > "$out/bin/wesnoth${suffix}"
    #!${stdenvNoCC.shell}
    open -na "$app_bundle" --args "\$@"
    EOF
    chmod +x "$out/bin/wesnoth${suffix}"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      (
        if enableDevel then
          # Devel matches odd minor release numbers
          "^(\\d+\\.\\d*[13579]\\.\\d+.*)$"
        else
          # Stable matches even minor release numbers
          "^(\\d+\\.\\d*[02468]\\.\\d+)$"
      )
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
    maintainers = with lib.maintainers; [ niklaskorz ];
    platforms = lib.platforms.unix;
    mainProgram = "wesnoth${suffix}";
  };
})
