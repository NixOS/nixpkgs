{
  lib,
  stdenvNoCC,
  makeBinaryWrapper,
  widelands-unwrapped,
}:

stdenvNoCC.mkDerivation {
  pname = "widelands";
  inherit (widelands-unwrapped) version;

  dontUnpack = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  # Copy ~600 MiB of data/ locally rather than caching on Hydra, without
  # retaining a reference to src.
  preferLocalBuild = true;
  allowSubstitutes = false;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/widelands"

    makeWrapper "${widelands-unwrapped}/bin/widelands" "$out/bin/widelands" \
      --add-flags "--datadir=$out/share/widelands"

    ln -s "${widelands-unwrapped}"/share/widelands/* "$out/share/widelands/"
    cp -r --no-preserve=mode "${widelands-unwrapped.src}"/data/* "$out/share/widelands/"
    printf '%s\n' "${widelands-unwrapped.version}" > "$out/share/widelands/datadirversion"

    ln -s "${widelands-unwrapped}/share/man" "$out/share/man"
    ${lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      ln -s "${widelands-unwrapped}/share/icons" "$out/share/icons"
      ln -s "${widelands-unwrapped}/share/metainfo" "$out/share/metainfo"
      mkdir -p "$out/share/applications"
      substitute "${widelands-unwrapped}/share/applications/org.widelands.Widelands.desktop" \
        "$out/share/applications/org.widelands.Widelands.desktop" \
        --replace-fail "Exec=widelands" "Exec=$out/bin/widelands"
    ''}

    runHook postInstall
  '';

  passthru = {
    unwrapped = widelands-unwrapped;
  };

  meta = widelands-unwrapped.meta // {
    description = "RTS with multiple-goods economy";
    hydraPlatforms = [ ];
  };
}
