{ lib
, bitlist
, buildPythonPackage
, fetchpatch
, fetchPypi
, fountains
, parts
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "fe25519";
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VwCw/sS8Pzhscoa6yCRGbB9X+CtRVn8xyBEpKfGyhhY=";
  };

  patches = [
    # https://github.com/nthparty/fe25519/pull/1
    (fetchpatch {
      name = "relax-setuptools-dependency.patch";
      url = "https://github.com/nthparty/fe25519/commit/0565f60ddbb1aa4755c68edc85b7df12a3a7311e.patch";
      hash = "sha256-FcqkHPdkYN6y+Pvviul2wDsmhhcycfRGqFhmX5sxo1k=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bitlist
    fountains
    parts
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--doctest-modules --ignore=docs --cov=fe25519 --cov-report term-missing" ""
  '';

  pythonImportsCheck = [
    "fe25519"
  ];

  meta = with lib; {
    description = "Python field operations for Curve25519's prime";
    homepage = "https://github.com/BjoernMHaase/fe25519";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
