{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, dataclasses
, kafka-python
, cython
, zlib
}:

buildPythonPackage rec {
  pname = "aiokafka";
  version = "0.7.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-D+91k4zVg28qPbWIrvyXi6WtDs1jeJt9jFGsrSBA3cs=";
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    kafka-python
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ];

  # checks require running kafka server
  doCheck = false;

  pythonImportsCheck = [ "aiokafka" ];

  meta = with lib; {
    description = "Kafka integration with asyncio";
    homepage = "https://aiokafka.readthedocs.org";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
