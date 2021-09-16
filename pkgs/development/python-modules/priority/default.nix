{ lib, buildPythonPackage, fetchPypi, pytest, hypothesis }:

buildPythonPackage rec {
  pname = "priority";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c965d54f1b8d0d0b19479db3924c7c36cf672dbf2aec92d43fbdaf4492ba18c0";
  };

  patches = [
    # https://github.com/python-hyper/priority/pull/135
    ./deadline.patch
  ];

  checkInputs = [ pytest hypothesis ];
  checkPhase = ''
    PYTHONPATH="src:$PYTHONPATH" pytest
  '';

  meta = with lib; {
    homepage = "https://python-hyper.org/priority/";
    description = "A pure-Python implementation of the HTTP/2 priority tree";
    license = licenses.mit;
    maintainers = [ maintainers.qyliss ];
  };
}
