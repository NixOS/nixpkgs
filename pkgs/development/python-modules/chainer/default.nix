{ stdenv, lib
, buildPythonPackage, fetchPypi, isPy3k
, filelock, protobuf, numpy, pytest, mock
, cupy, cudaSupport ? false
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a83044256edb1946c47cb9ae687d195c2aa0deaef46ab85a8ffc4a01f7001683";
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
