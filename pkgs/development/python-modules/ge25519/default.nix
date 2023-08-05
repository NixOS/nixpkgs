{ lib
, bitlist
, buildPythonPackage
, fe25519
, fetchPypi
, fountains
, parts
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "ge25519";
  version = "1.4.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oOvrfRSpvwfCcmpV7FOxcBOW8Ex89d2+otjORrzX4o0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    fe25519
    parts
    bitlist
    fountains
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--doctest-modules --ignore=docs --cov=ge25519 --cov-report term-missing" ""
  '';

  pythonImportsCheck = [
    "ge25519"
  ];

  meta = with lib; {
    description = "Python implementation of Ed25519 group elements and operations";
    homepage = "https://github.com/nthparty/ge25519";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
