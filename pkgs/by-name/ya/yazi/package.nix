{
  lib,
  runCommand,
  makeWrapper,
  yazi-unwrapped,

  withRuntimeDeps ? true,
  withFile ? true,
  file,
  withJq ? true,
  jq,
  withPoppler ? true,
  poppler_utils,
  withUnar ? true,
  unar,
  withFfmpegthumbnailer ? true,
  ffmpegthumbnailer,
  withFd ? true,
  fd,
  withRipgrep ? true,
  ripgrep,
  withFzf ? true,
  fzf,
  withZoxide ? true,
  zoxide,
  settings ? { },
  formats,
  plugins ? { },
  flavors ? { },
  initLua ? null,
}:

let
  runtimePaths =
    with lib;
    [ ]
    ++ optional withFile file
    ++ optional withJq jq
    ++ optional withPoppler poppler_utils
    ++ optional withUnar unar
    ++ optional withFfmpegthumbnailer ffmpegthumbnailer
    ++ optional withFd fd
    ++ optional withRipgrep ripgrep
    ++ optional withFzf fzf
    ++ optional withZoxide zoxide;

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
          ${lib.concatMapStringsSep "\n" (
            lib.mapAttrsToList (name: value: "ln -s ${value} $out/plugins/${name}") plugins
          )}
        ''}

        mkdir $out/flavors
        ${lib.optionalString (flavors != { }) ''
          ${lib.concatMapStringsSep "\n" (
            lib.mapAttrsToList (name: value: "ln -s ${value} $out/flavors/${name}") flavors
          )}
        ''}


        ${lib.optionalString (initLua != null) "ln -s ${initLua} $out/init.lua"}
      '';
in
if (!withRuntimeDeps && configHome == null) then
  yazi-unwrapped
else
  runCommand yazi-unwrapped.name
    {
      inherit (yazi-unwrapped) pname version meta;

      nativeBuildInputs = [ makeWrapper ];
    }
    ''
      mkdir -p $out/bin
      ln -s ${yazi-unwrapped}/share $out/share
      makeWrapper ${yazi-unwrapped}/bin/yazi $out/bin/yazi \
        ${lib.optionalString withRuntimeDeps "--prefix PATH : \"${lib.makeBinPath runtimePaths}\""} \
        ${lib.optionalString (configHome != null) "--set YAZI_CONFIG_HOME ${configHome}"}
    ''
