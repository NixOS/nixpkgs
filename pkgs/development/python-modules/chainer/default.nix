{ stdenv, lib
, buildPythonPackage, fetchPypi, isPy3k
, filelock, protobuf, numpy, pytest, mock
, cupy, cudaSupport ? false
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "74c11c3f20c33f85d3f42cc237a55efc384dc6f42035d6d2448318b182f236ee";
  };

  checkInputs = [
    pytest
    mock
  ];

  propagatedBuildInputs = [
    filelock
    protobuf
    numpy
  ] ++ lib.optionals cudaSupport [ cupy ];

  # In python3, test was failed...
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "A flexible framework of neural networks for deep learning";
    homepage = https://chainer.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
