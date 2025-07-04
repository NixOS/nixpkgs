{
  lib,
  stdenv,
  fetchFromGitHub,
  qtgraphicaleffects,
  themeConfig ? { },
}:
let
  customToString = x: if builtins.isBool x then lib.boolToString x else toString x;
  configLines = lib.mapAttrsToList (name: value: lib.nameValuePair name value) themeConfig;
  configureTheme =
    "cp theme.conf theme.conf.orig \n"
    + (lib.concatMapStringsSep "\n" (
      configLine:
      "grep -q '^${configLine.name}=' theme.conf || echo '${configLine.name}=' >> \"$1\"\n"
      + "sed -i -e 's/^${configLine.name}=.*$/${configLine.name}=${
        lib.escape [ "/" "&" "\\" ] (customToString configLine.value)
      }/' theme.conf"
    ) configLines);
in
stdenv.mkDerivation {
  pname = "sddm-chili-theme";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "6516d50176c3b34df29003726ef9708813d06271";
    sha256 = "036fxsa7m8ymmp3p40z671z163y6fcsa9a641lrxdrw225ssq5f3";
  };

  propagatedBuildInputs = [
    qtgraphicaleffects
  ];

  dontWrapQtApps = true;

  preInstall = configureTheme;

  postInstall = ''
    mkdir -p $out/share/sddm/themes/chili

    mv * $out/share/sddm/themes/chili/
  '';

  postFixup = ''
    mkdir -p $out/nix-support

    echo ${qtgraphicaleffects} >> $out/nix-support/propagated-user-env-packages
  '';
  meta = with lib; {
    license = licenses.gpl3;
    maintainers = with lib.maintainers; [ sents ];
    homepage = "https://github.com/MarianArlt/sddm-chili";
    description = "Chili login theme for SDDM";
    longDescription = ''
      Chili is hot, just like a real chili!
      Spice up the login experience for your users, your family and yourself.
      Chili reduces all the clutter and leaves you with a clean, easy to use, login interface with a modern yet classy touch.
    '';
  };
}
