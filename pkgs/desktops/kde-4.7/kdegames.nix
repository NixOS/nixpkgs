{ kde, kdelibs, qca2, twisted, pythonPackages, sip, makeWrapper, kdebindings,
  openal, libsndfile, qhull }:

kde rec {
  buildInputs = [ kdelibs qca2 pythonPackages.python pythonPackages.wrapPython
    openal libsndfile qhull ] ++ pythonPath;

  pythonPath = [ pythonPackages.twisted kdebindings.pykde4 ];

  # TODO: ggz

  postInstall = "wrapPythonPrograms";

  meta = {
    description = "KDE Games";
    license = "GPL";
  };
}
