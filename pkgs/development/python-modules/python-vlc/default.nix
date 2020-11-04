{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, libvlc
, substituteAll
}:

buildPythonPackage rec {
  pname = "python-vlc";
  version = "3.0.11115";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4d3bdddfce84a8fb1b2d5447193a0239c55c16ca246e5194d48efd59c4e236b";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  patches = [
    (substituteAll {
      src = ./vlc-paths.patch;
      libvlcPath="${libvlc}/lib/libvlc.so.5";
    })
  ];

  doCheck = false; # no tests

  meta = with lib; {
    homepage = "https://wiki.videolan.org/PythonBinding";
    maintainers = with maintainers; [ tbenst ];
    description = "Python bindings for VLC, the cross-platform multimedia player and framework";
    license = licenses.lgpl21Plus;
  };
}
