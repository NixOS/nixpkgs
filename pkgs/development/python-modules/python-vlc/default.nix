{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  libvlc,
  substituteAll,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-vlc";
  version = "3.0.20123";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JE+7njkqAyaEH8qSbW0SoqNsVGmCGR9JPxSPoZ5msdQ=";
  };

  patches = [
    # Patch path for VLC
    (substituteAll {
      src = ./vlc-paths.patch;
      libvlcPath = "${libvlc}/lib/libvlc.so.5";
    })
  ];

  propagatedBuildInputs = [ setuptools ];

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
