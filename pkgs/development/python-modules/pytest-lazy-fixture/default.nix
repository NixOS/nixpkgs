{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-lazy-fixture";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b0hmnsxw4s2wf9pks8dg6dfy5cx3zcbzs8517lfccxsfizhqz8f";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Helps to use fixtures in pytest.mark.parametrize";
    homepage = "https://github.com/pytest-dev/pytest-repeat";
    license = licenses.mit;
    maintainers = with maintainers; [ tobim ];
  };
}
