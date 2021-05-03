{ lib
, buildPythonPackage
, fetchPypi
, chardet
, attrs
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "debut";
  version = "0.9.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3a71e475295f4cf4292440c9c7303ebca0309d395536d2a7f86a5f4d7465dc1";
  };

  dontConfigure = true;

  propagatedBuildInputs = [
    chardet
    attrs
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "debut"
  ];

  meta = with lib; {
    description = "Python library to parse Debian deb822-style control and copyright files ";
    homepage = "https://github.com/nexB/debut";
    license = with licenses; [ asl20 bsd3 mit ];
    maintainers = teams.determinatesystems.members;
  };
}
