{ lib
, buildPythonPackage
, fetchPypi
, six
, isPy27
}:

buildPythonPackage rec {
  pname = "mongoquery";
  version = "1.4.2";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd19fc465f0aa9feb3070f144fde41fc68cf28ea32dd3b7565f7df3ab6fc0ac2";
  };

  propagatedBuildInputs = [
    six
  ];

  pythonImportsCheck = [
    "mongoquery"
  ];

  meta = with lib; {
    description = "A python implementation of mongodb queries";
    homepage = "https://github.com/kapouille/mongoquery";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ misuzu ];
  };
}
