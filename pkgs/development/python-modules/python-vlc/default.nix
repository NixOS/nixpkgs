{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, libvlc
, substituteAll
}:

buildPythonPackage rec {
  pname = "python-vlc";
  version = "3.0.16120";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kvmP7giPcr1tBjs7MxLQvSmzfnrWXd6zpzAzIDAMKAc=";
  };

  patches = [
    # Patch path for VLC
    (substituteAll {
      src = ./vlc-paths.patch;
      libvlcPath="${libvlc}/lib/libvlc.so.5";
    })
  ];

  propagatedBuildInputs = [
    setuptools
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "vlc" ];

  meta = with lib; {
    description = "Python bindings for VLC, the cross-platform multimedia player and framework";
    homepage = "https://wiki.videolan.org/PythonBinding";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ tbenst ];
  };
}
