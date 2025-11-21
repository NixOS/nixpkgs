{
  writeTextFile,
  lib,
  frotz,
  callPackage,
  interpreter ? frotz,
}:
let
  data = callPackage ./data.nix { };
in
writeTextFile {
  name = "zork1-${data.version}";

  text = ''
    ${lib.getExe interpreter} $@ ${data}/share/games/zork1.z3
  '';

  destination = "/bin/zork1";
  executable = true;
  passthru = { inherit data; };

  meta = data.meta // {
    mainProgram = "zork1";
  };
}
