{ stdenv
, fetchPypi
, buildPythonPackage
, urllib3
, isPy3k
, mock
, sqlalchemy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "crate";
  version = "0.24.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "028q9r1qyqkq185awkazhplfy7y1081963fnjzi3kf3lxvz6yhay";
  };

  propagatedBuildInputs = [
    urllib3
  ];

  checkInputs = [
    pytestCheckHook
    sqlalchemy
    mock
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/crate/crate-python";
    description = "A Python client library for CrateDB";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
