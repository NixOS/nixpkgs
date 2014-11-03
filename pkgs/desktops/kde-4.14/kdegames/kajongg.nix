{ kde, kdelibs, libkdegames, pythonPackages, sqlite,  pykde4 }:
kde rec {

  buildInputs = [ kdelibs libkdegames pythonPackages.python pythonPackages.wrapPython sqlite ] ++ pythonPath;

  pythonPath = [ pythonPackages.twisted pykde4 ];

  postInstall = "wrapPythonPrograms";

  meta = {
    description = "an ancient Chinese board game for 4 players";
  };
}
