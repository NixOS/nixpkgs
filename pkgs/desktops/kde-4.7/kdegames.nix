{ kde, kdelibs, qca2, twisted, pythonPackages, sip, makeWrapper, pykde4,
  openal, libsndfile, qhull, sqlite, pkgconfig }:

kde rec {
  buildInputs = [ kdelibs qca2 pythonPackages.python pythonPackages.wrapPython
    openal libsndfile qhull sqlite ] ++ pythonPath;

  pythonPath = [ pythonPackages.twisted pykde4 ];

  buildNativeInputs = [ pkgconfig ];

  # TODO: ggz

  postInstall = "wrapPythonPrograms";

  meta = {
    description = "KDE Games";
    license = "GPL";
  };
}
