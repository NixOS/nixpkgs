{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, dataclasses
, msgpack
, pyyaml
, backports-datetime-fromisoformat
, typing-extensions
, isPy36
}:

buildPythonPackage rec {
  pname = "mashumaro";
  version = "2.9";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NDtuLT5DLjGXNojEyIIdzW70H9MyZLmSr8Suy/0VXxg=";
  };

  propagatedBuildInputs = [
    msgpack
    pyyaml
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.6") [
    dataclasses
    backports-datetime-fromisoformat
  ];

  meta = with lib; {
    description = "Fast serialization framework on top of dataclasses";
    homepage = "https://github.com/Fatal1ty/mashumaro";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
