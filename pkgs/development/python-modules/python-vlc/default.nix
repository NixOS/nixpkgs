{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, vlc
, substituteAll
}:

buildPythonPackage rec {
  pname = "python-vlc";
  version = "3.0.7110";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ydnqwwgpwq1kz1pjrc7629ljzdd30izymjylsbzzyq8pq6wl6w2";
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
