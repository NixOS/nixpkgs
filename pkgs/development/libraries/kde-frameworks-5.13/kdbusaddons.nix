{ mkDerivation, lib
, extra-cmake-modules
, qtx11extras
}:

mkDerivation {
  name = "kdbusaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kquitapp5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
