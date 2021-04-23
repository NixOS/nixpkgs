{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-cov
}:
buildPythonPackage rec {
  pname = "multimethod";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b9c6f85ecf187f14a3951fff319643e1fac3086d757dec64f2469e1fd136b65d";
  };

  checkInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythomImportsCheck = [
    "multimethod"
  ];

  meta = with lib; {
    description = "Multiple argument dispatching";
    homepage = "https://github.com/coady/multimethod";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
