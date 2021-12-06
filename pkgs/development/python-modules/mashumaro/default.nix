{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, dataclasses
, msgpack
, pyyaml
, backports-datetime-fromisoformat
, typing-extensions
, autopep8
, isPy36
}:

buildPythonPackage rec {
  pname = "mashumaro";
  version = "2.9";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "276ced7e9e3cb22e5d7c14748384a5cf5d9002257c0ed50c0e075b68011bb6d0";
  };

  buildInputs = [ autopep8 ];

  propagatedBuildInputs = [
    msgpack
    pyyaml
    typing-extensions
  ] ++ lib.optionals isPy36 [
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
