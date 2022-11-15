{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prefixed";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gfTjvBUEbncnE6uA8IaQ5hxSzOsgFBQldU6rWwCxMMk=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "prefixed" ];

  meta = with lib; {
    description = "Prefixed alternative numeric library";
    homepage = "https://github.com/Rockhopper-Technologies/prefixed";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
