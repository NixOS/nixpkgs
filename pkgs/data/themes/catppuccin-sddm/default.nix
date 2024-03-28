{ lib
, stdenv
, fetchFromGitHub
, qtsvg
, qtquickcontrols2
, qtgraphicaleffects
, flavor ? "mocha"
, themeConfig ? { }
}:

let
  customToString = x:
    if builtins.isInt x then toString x
    else if builtins.isBool x then "\"${lib.boolToString x}\""
    else "\"${toString x}\"";
  configLines = lib.mapAttrsToList (name: value: lib.nameValuePair name value) themeConfig;
  configureTheme = ''
    for style_dir in src/catppuccin-{latte,frappe,macchiato,mocha}; do
      cp $style_dir/theme.conf $style_dir/theme.conf.orig
      ${lib.concatMapStringsSep "\n"
        (configLine: ''
          grep -q '^${configLine.name}=' $style_dir/theme.conf || echo '${configLine.name}=' >> "$style_dir/theme.conf"
          sed -i -e 's/^${configLine.name}=.*$/${configLine.name}=${lib.escape [ "/" "&" "\\"] (customToString configLine.value)}/' $style_dir/theme.conf
        '')
        configLines}
    done
  '';

  validFlavors = [ "latte" "frappe" "macchiato" "mocha" ];
  pname = "catppuccin-sddm";
in

lib.checkListOfEnum "${pname}: flavor" validFlavors [ flavor ]

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "unstable-2023-08-08";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "7fc67d1027cdb7f4d833c5d23a8c34a0029b0661";
    hash = "sha256-SjYwyUvvx/ageqVH5MmYmHNRKNvvnF3DYMJ/f2/L+Go=";
  };

  propagatedBuildInputs = [
    qtsvg
    qtquickcontrols2
    qtgraphicaleffects
  ];

  dontWrapQtApps = true;

  preInstall = configureTheme;

  postInstall = ''
    mkdir -p $out/share/sddm/themes

    mv src/catppuccin-${flavor} $out/share/sddm/themes/catppuccin-${flavor}
  '';

  postFixup = ''
    mkdir -p $out/nix-support

    echo ${qtsvg} >> $out/nix-support/propagated-user-env-packages
    echo ${qtquickcontrols2} >> $out/nix-support/propagated-user-env-packages
    echo ${qtgraphicaleffects} >> $out/nix-support/propagated-user-env-packages
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = with lib.maintainers; [ gigglesquid ];
    platforms = platforms.linux;
    homepage = "https://github.com/catppuccin/sddm";
    description = "Soothing pastel theme for SDDM";
     longDescription = ''
       Installs one of the Latte, Frappé, Macchiato, or Mocha flavors, including dependencies via propagated-user-env-packages.
       Defaults to Mocha flavor.

       Available SDDM themes: `catppuccin-latte` `catppuccin-frappe` `catppuccin-macchiato` `catppuccin-mocha`.

      `flavor` can be set to select the catppuccin flavor to install
       Valid values are: `latte` `frappe` `macchiato` `mocha`.

      `themeConfig` can be set to adjust vaulues as per https://github.com/catppuccin/sddm#configuration.
       All values should be strings with the exception of FontSize, which should be an int (Bools can also be bools).
       ---
       Example:
       ```
       environment.systemPackages = with pkgs; [
         (catppuccin-sddm { flavor = "mocha"; themeConfig = { Font = "Some Other Font"; FontSize = 10; ClockEnabled = "false"; }; })
       ];

       services.xserver.displayManager.sddm.theme = "catppuccin-mocha";
       ```
    '';
  };
})
