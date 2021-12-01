{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, hpack
, hyperframe
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "h2";
  version = "4.0.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb7ac7099dd67a857ed52c815a6192b6b1f5ba6b516237fc24a085341340593d";
  };

  patches = [
    # Workaround issues with hypothesis 6.6
    # https://github.com/python-hyper/h2/pull/1248
    (fetchpatch {
      url = "https://github.com/python-hyper/h2/commit/0646279dab694a89562846c810202ce2c0b49be3.patch";
      sha256 = "1k0fsxwq9wbv15sc9ixls4qmxxghlzpflf3awm66ar9m2ikahiak";
    })
  ];

  propagatedBuildInputs = [
    hpack
    hyperframe
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [
    "h2.connection"
    "h2.config"
  ];

  meta = with lib; {
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "http://hyper.rtfd.org/";
    license = licenses.mit;
  };
}
