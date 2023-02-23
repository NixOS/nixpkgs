{ lib
, buildPythonPackage
, fetchPypi
, python3

  # nativeCheckInputs
, hypothesis
, unittestCheckHook

}:

buildPythonPackage rec {
  pname = "rtp";
  version = "0.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xUfI8lQD/EhA4NrE4y+KHlie+wwBWkYkDqFLVWKwOzA=";
  };

  # Remove unused dependencies until upstream fixed their setup.py
  postPatch = ''
    sed -i '/"mypy"/d' setup.py
    sed -i '/"flask"/d' setup.py
    sed -i '/"six"/d' setup.py
  '';

  nativeCheckInputs = [
    hypothesis
    unittestCheckHook
  ];

  unittestFlagsArray = [ "-s" "tests" "-v" ];

  pythonImportsCheck = [
    "rtp"
  ];


  meta = with lib; {
    description = "A library for decoding/encoding rtp packets";
    homepage = "https://github.com/bbc/rd-apmm-python-lib-rtp";
    license = licenses.asl20;
    maintainers = with maintainers; [ fleaz ];
  };
}
