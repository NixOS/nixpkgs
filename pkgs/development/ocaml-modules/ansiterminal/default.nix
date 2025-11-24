{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage (finalAttrs: {
  pname = "ANSITerminal";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "Chris00";
    repo = "ANSITerminal";
    tag = finalAttrs.version;
    hash = "sha256-MBSKjpEhLjZLyGNtH/RDiWNIDU5f3uo9SLfXPQSzWBQ=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace 'libraries unix bytes' 'libraries unix'
  '';

  doCheck = true;

  meta = {
    description = "Module allowing to use the colors and cursor movements on ANSI terminals";
    longDescription = ''
      ANSITerminal is a module allowing to use the colors and cursor
      movements on ANSI terminals. It also works on the windows shell (but
      this part is currently work in progress).
    '';
    homepage = "https://github.com/Chris00/ANSITerminal";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jirkamarsik ];
  };
})
