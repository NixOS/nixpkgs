{ lib
, buildPythonPackage
, fetchPypi
, stdenv
, python
}:

buildPythonPackage rec {
  version = "1.8.2";
  format = "setuptools";
  pname = "pyperclip";

  src = fetchPypi {
    inherit pname version;
    sha256 = "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57";
  };

  # No such file or directory: 'pbcopy'
  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    ${python.interpreter} tests/test_pyperclip.py
  '';

  pythonImportsCheck = [ "pyperclip" ];

  meta = with lib; {
    homepage = "https://github.com/asweigart/pyperclip";
    license = licenses.bsd3;
    description = "Cross-platform clipboard module";
    maintainers = with maintainers; [ dotlambda ];
  };
}
