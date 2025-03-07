{
  runtimeShell,
  symlinkJoin,
  writeTextFile,
}:

{ emulator, rom }:

assert emulator.version == rom.version;

let
  runScript = writeTextFile {
    name = "run-x16";
    text = ''
      #!${runtimeShell}

      defaultRom="${rom}/share/x16-rom/rom.bin"

      exec "${emulator}/bin/x16emu" -rom $defaultRom "$@"
    '';
    executable = true;
    destination = "/bin/run-x16";
  };
in
symlinkJoin {
  pname = "run-x16";
  inherit (emulator) version;

  paths = [
    emulator
    rom
    runScript
  ];
}
