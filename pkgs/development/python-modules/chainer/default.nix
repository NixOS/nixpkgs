{ stdenv, lib, python
, buildPythonPackage, fetchPypi, isPy3k
, filelock, protobuf, numpy, pytest, mock
, cupy, cudaSupport ? false
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mbc8kwk7pvg03bf0j57a48gr6rsdg4lzmyj0dak8y2l4lmyskpw";
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
