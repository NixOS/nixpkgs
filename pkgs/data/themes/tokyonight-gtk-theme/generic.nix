{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  writeScript,
  gtk-engine-murrine,
  gnome-themes-extra,
  prefix ? "",
  type ? "",
  variantName ? "",
  variant ? "",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "${prefix}_${type}-${variantName}";
  version = "unstable-2023-05-31";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyo-Night-GTK-Theme";
    rev = "e9790345a6231cd6001f1356d578883fac52233a";
    hash = "sha256-Q9UnvmX+GpvqSmTwdjU4hsEsYhA887wPqs5pyqbIhmc=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
    gnome-themes-extra
  ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{${type},${prefix}}
    cp -a ${type}/Tokyonight-${variant} $out/share/${type}
    cp -a LICENSE $out/share/${prefix}

    runHook postInstall
  '';

  passthru = {
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl common-updater-scripts tree jq
      res="$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
        -sL "https://api.github.com/repos/${finalAttrs.src.owner}/${finalAttrs.src.repo}/commits/HEAD")"

      rev="$(echo $res | jq '.sha' --raw-output)"
      version="unstable-$(echo $res | jq '.commit | .author | .date' --raw-output | sed 's/T.*$//')"
      update-source-version ${prefix}-variants.${type}.${variantName} "$version" "$rev" --ignore-same-hash

      commonjq1='.[] .contents .[] | {(.name): .name} | walk(if type=="object" then with_entries(.key|=ascii_downcase) else . end)'
      commonjq2='reduce inputs as $in (.; . + $in)'
      commontree="-dJ -L 1 --noreport ${finalAttrs.src}"

      echo $(tree $commontree/icons | jq "$commonjq1" | jq "$commonjq2" | jq '{icons: .}') \
        $(tree $commontree/themes | jq "$commonjq1" | jq "$commonjq2" | jq '{themes: .}') | \
        jq 'reduce inputs as $in (.; . + $in)' | sed "s/[tT]okyonight-//g" > \
        "$(git rev-parse --show-toplevel)/pkgs/data/themes/${prefix}/variants.json"
    '';

    # For "full" in default.nix
    ptype = type;
    pvariant = variant;
  };

  meta = with lib; {
    description = "A GTK theme based on the Tokyo Night colour palette";
    homepage = "https://www.pling.com/p/1681315";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      garaiza-93
      Madouura
    ];
  };
})
