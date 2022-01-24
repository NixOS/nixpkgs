{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "5.2.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dd1c93edb444b33ba2274b66f63def8a327d607c6c790772f448a53b6ea59ce";
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
