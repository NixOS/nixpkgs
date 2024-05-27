{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  packaging,
  pythonOlder,
  typing-extensions,
  pytest,
}:

buildPythonPackage rec {
  pname = "jpype1";
  version = "1.5.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    pname = "JPype1";
    inherit version;
    hash = "sha256-QlpuGWav3VhItgwmiLyut+QLpQSmhvERRYlmjgYx6Hg=";
  };

  propagatedBuildInputs = [ packaging ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  nativeCheckInputs = [ pytest ];

  # required openjdk (easy) but then there were some class path issues
  # when running the tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/originell/jpype/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.asl20;
    description = "A Python to Java bridge";
  };
}
