{ lib, fetchPypi, buildPythonPackage, numpy
}:

buildPythonPackage rec {
  pname = "plyfile";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59a25845d00a51098e6c9147c3c96ce89ad97395e256a4fabb4aed7cf7db5541";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage    = "https://github.com/dranjan/python-plyfile";
    maintainers = with maintainers; [ abbradar ];
  };

}
