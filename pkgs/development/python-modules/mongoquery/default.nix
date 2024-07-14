{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  isPy27,
}:

buildPythonPackage rec {
  pname = "mongoquery";
  version = "1.4.2";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vRn8Rl8Kqf6zBw8UT95B/GjPKOoy3Tt1ZfffOrb8CsI=";
  };

  propagatedBuildInputs = [ six ];

  pythonImportsCheck = [ "mongoquery" ];

  meta = with lib; {
    description = "Python implementation of mongodb queries";
    homepage = "https://github.com/kapouille/mongoquery";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ misuzu ];
  };
}
