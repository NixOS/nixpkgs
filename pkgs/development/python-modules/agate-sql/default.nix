{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, agate
, sqlalchemy
, crate
, pytestCheckHook
, geojson
}:

buildPythonPackage rec {
  pname = "agate-sql";
  version = "0.5.8";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "581e062ae878cc087d3d0948670d46b16589df0790bf814524b0587a359f2ada";
  };

  propagatedBuildInputs = [ agate sqlalchemy ];

  checkInputs = [ crate geojson pytestCheckHook ];

  pythonImportsCheck = [ "agatesql" ];

  meta = with lib; {
    description = "Adds SQL read/write support to agate.";
    homepage = "https://github.com/wireservice/agate-sql";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ vrthra ];
  };
}
