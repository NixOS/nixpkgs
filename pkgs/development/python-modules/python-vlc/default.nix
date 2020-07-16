{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, vlc
, substituteAll
}:

buildPythonPackage rec {
  pname = "python-vlc";
  version = "3.0.10114";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fq0w1pk2z7limhiyk8f3bqwa67yfgwcszd0v6ipy9x8psas5a61";
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
