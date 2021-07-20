{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook, pytest-runner, pytest-cov
, isPy3k
}:

buildPythonPackage rec {
  pname = "multidict";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25b4e5f22d3a37ddf3effc0710ba692cfc792c2b9edfb9c05aefe823256e84d5";
  };

  checkInputs = [ pytestCheckHook pytest-runner pytest-cov ];

  disabled = !isPy3k;

  meta = with lib; {
    description = "Multidict implementation";
    homepage = "https://github.com/aio-libs/multidict/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
