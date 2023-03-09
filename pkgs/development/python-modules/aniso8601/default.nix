{ lib
, buildPythonPackage
, python-dateutil
, fetchPypi
, isPy3k
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "9.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cuMRdmfu32aVG7LZP0KWpWuUsHioqVkFoFJhH7PxuXM=";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.optional (!isPy3k) mock;

  pythonImportsCheck = [ "aniso8601" ];

  meta = with lib; {
    description = "Python Parser for ISO 8601 strings";
    homepage = "https://bitbucket.org/nielsenb/aniso8601";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
