{ buildPythonPackage, fetchPypi, lib, pytestCheckHook }:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c01fbaf62ad2eb791e97158d1f30349e830bee2dd3e9503a87f6c3ffae8d1cf0";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "packageurl" ];

  meta = with lib; {
    description = "Python parser and builder for package URLs";
    homepage = "https://github.com/package-url/packageurl-python";
    license = licenses.mit;
    maintainers = with maintainers; [ armijnhemel ];
  };
}
