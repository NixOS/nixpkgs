{
  lib,
  formats,
  runCommand,
  makeWrapper,

  runtimeDeps ? (ps: ps),

  # deps
  file,
  yazi-unwrapped,

  # default optional deps
  jq,
  poppler_utils,
  _7zz,
  ffmpegthumbnailer,
  fd,
  ripgrep,
  fzf,
  zoxide,
  imagemagick,
  chafa,

  settings ? { },
  plugins ? { },
  flavors ? { },
  initLua ? null,
}:

let
  defaultDeps = [
    jq
    poppler_utils
    _7zz
    ffmpegthumbnailer
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
    chafa
  ];
  runtimePaths = [ file ] ++ (runtimeDeps defaultDeps);

  settingsFormat = formats.toml { };

  files = [
    "yazi"
    "theme"
    "keymap"
  ];

  configHome =
    if (settings == { } && initLua == null && plugins == { } && flavors == { }) then
      null
    else
      runCommand "YAZI_CONFIG_HOME" { } ''
        mkdir -p $out
        ${lib.concatMapStringsSep "\n" (
          name:
          lib.optionalString (settings ? ${name} && settings.${name} != { }) ''
            ln -s ${settingsFormat.generate "${name}.toml" settings.${name}} $out/${name}.toml
          ''
        ) files}

        mkdir $out/plugins
        ${lib.optionalString (plugins != { }) ''
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList (name: value: "ln -s ${value} $out/plugins/${name}") plugins
          )}
        ''}

        mkdir $out/flavors
        ${lib.optionalString (flavors != { }) ''
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList (name: value: "ln -s ${value} $out/flavors/${name}") flavors
          )}
        ''}


        ${lib.optionalString (initLua != null) "ln -s ${initLua} $out/init.lua"}
      '';
in
runCommand yazi-unwrapped.name
  {
    inherit (yazi-unwrapped) pname version meta;

    nativeBuildInputs = [ makeWrapper ];
  }
  ''
    mkdir -p $out/bin
    ln -s ${yazi-unwrapped}/share $out/share
    ln -s ${yazi-unwrapped}/bin/ya $out/bin/ya
    makeWrapper ${yazi-unwrapped}/bin/yazi $out/bin/yazi \
      --prefix PATH : ${lib.makeBinPath runtimePaths} \
      ${lib.optionalString (configHome != null) "--set YAZI_CONFIG_HOME ${configHome}"}
  ''
