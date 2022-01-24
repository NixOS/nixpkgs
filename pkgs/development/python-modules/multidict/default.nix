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
    sha256 = "5ff3bd75f38e4c43f1f470f2df7a4d430b821c4ce22be384e1459cb57d6bb013";
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
