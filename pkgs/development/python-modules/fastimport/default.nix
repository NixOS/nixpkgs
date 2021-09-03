{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "fastimport";
  version = "0.9.13";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "486135a39edb85808fdbbe2c8009197978800a4544fca56cc2074df32e1304f3";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [ "fastimport" ];

  meta = with lib; {
    homepage = "https://github.com/jelmer/python-fastimport";
    description = "VCS fastimport/fastexport parser";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Plus;
  };
}
