{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, libvlc
, substituteAll
}:

buildPythonPackage rec {
  pname = "python-vlc";
  version = "3.0.12118";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vm8vfDA/aACFHKzAFt8cbu7AlK1j4KSdh9udaYCU8fs=";
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
