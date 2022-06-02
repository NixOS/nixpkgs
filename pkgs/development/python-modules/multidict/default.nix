{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "6.0.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-X/O9dfOOTEPx9HDy33pNQwuCHEziK+OE4UWctX1rsBM=";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multidict" ];

  meta = with lib; {
    description = "Multidict implementation";
    homepage = "https://github.com/aio-libs/multidict/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
