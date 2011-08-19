{ kde, kdelibs, qca2, twisted, pythonPackages, sip, makeWrapper, pykde4,
  openal, libsndfile, qhull }:

kde rec {
  buildInputs = [ kdelibs qca2 pythonPackages.python pythonPackages.wrapPython
    openal libsndfile qhull ] ++ pythonPath;

  pythonPath = [ pythonPackages.twisted pykde4 ];

  # TODO: ggz

  postInstall = "wrapPythonPrograms";

  meta = {
    description = "KDE Games";
    license = "GPL";
  };
}
