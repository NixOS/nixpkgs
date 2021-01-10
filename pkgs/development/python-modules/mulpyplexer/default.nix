{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mulpyplexer";
  version = "0.08";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zn5d1vyhfjp8x9z5mr9gv8m8gmi3s3jv3kqb790xzi1kqi0p4ya";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "mulpyplexer" ];

  meta = with lib; {
    description = "Multiplex interactions with lists of Python objects";
    homepage = "https://github.com/zardus/mulpyplexer";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
