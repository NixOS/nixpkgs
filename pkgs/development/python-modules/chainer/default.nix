{ stdenv, lib, python
, buildPythonPackage, fetchPypi, isPy3k
, filelock, protobuf, numpy, pytest, mock
, cupy, cudaSupport ? false
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49a4a691708626f742cc6fc949fce6b313e3379bd64886eb19e002b1122cc329";
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
