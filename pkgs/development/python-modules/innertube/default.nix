{ lib
, fetchPypi
, buildPythonPackage
, mediate
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "innertube";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uKGioZGs7skHTkbjsu8Ixnq7r3lZuKSum9FTkfSIz3Y=";
  };

  propagatedBuildInputs = [
    mediate
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "innertube"
  ];


  meta = with lib; {
    description = "Python client for Google's private InnerTube API";
    homepage = "https://github.com/tombulled/innertube";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
