{ lib, buildPythonPackage, fetchPypi, mock }:

buildPythonPackage rec {
  pname = "file-read-backwards";
  version = "3.0.0";

  src = fetchPypi {
    pname = "file_read_backwards";
    inherit version;
    sha256 = "sha256-USw+U0BDUnqPrioLcVGqJV8towPnf9QPfc9CoeCRzCY=";
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
