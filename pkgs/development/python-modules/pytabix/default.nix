{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, zlib
}:

buildPythonPackage rec {
  pname = "pytabix";
  version = "0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ldp5r4ggskji6qx4bp2qxy2vrvb3fam03ksn0gq2hdxgrlg2x07";
  };

  buildInputs = [ zlib ];

  doCheck = !isPy3k;
  preCheck = ''
    substituteInPlace test/test.py \
      --replace 'test_remote_file' 'dont_test_remote_file'
  '';
  pythonImportsCheck = [ "tabix" ];

  meta = with lib; {
    homepage = "https://github.com/slowkow/pytabix";
    description = "Python interface for tabix";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
