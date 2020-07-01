{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, vlc
, substituteAll
}:

buildPythonPackage rec {
  pname = "python-vlc";
  version = "3.0.9113";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5422b79d347b6419008ee91cfd9663edc37eaf2a0bd8fb9017d4cc2e5f249dda";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  patches = [
    (substituteAll {
      src = ./vlc-paths.patch;
      libvlcPath="${vlc}/lib/libvlc.so.5";
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
