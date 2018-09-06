{ stdenv, lib
, buildPythonPackage, fetchPypi, isPy3k
, filelock, protobuf, numpy, pytest, mock
, cupy, cudaSupport ? false
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9cc4d43e1ea3e0766e211e4e755dbb879f2cf27a805cfa52e32b99fd1e5f24dd";
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
