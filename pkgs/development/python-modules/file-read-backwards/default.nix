{ lib, buildPythonPackage, fetchPypi, mock }:

buildPythonPackage rec {
  pname = "file-read-backwards";
  version = "2.0.0";

  src = fetchPypi {
    pname = "file_read_backwards";
    inherit version;
    sha256 = "fd50d9089b412147ea3c6027e2ad905f977002db2918cf315d64eed23d6d6eb8";
  };

  nativeCheckInputs = [ mock ];
  pythonImportsCheck = [ "file_read_backwards" ];

  meta = with lib; {
    homepage = "https://github.com/RobinNil/file_read_backwards";
    description = "Memory efficient way of reading files line-by-line from the end of file";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
