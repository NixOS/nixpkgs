{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  libvlc,
  replaceVars,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-vlc";
  version = "3.0.21203";
  pyproject = true;

  src = fetchPypi {
    pname = "python_vlc";
    inherit version;
    hash = "sha256-UtBUSydrEeWLbAt0jD4FGPlPdLG0zTKMg6WerKvq0ew=";
  };

  patches = [
    # Patch path for VLC
    (replaceVars ./vlc-paths.patch {
      libvlc = "${libvlc}/lib/libvlc.so.5";
    })
  ];

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "vlc" ];

  meta = with lib; {
    description = "Python bindings for VLC, the cross-platform multimedia player and framework";
    homepage = "https://wiki.videolan.org/PythonBinding";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ tbenst ];
  };
}
