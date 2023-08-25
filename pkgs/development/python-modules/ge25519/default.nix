{ lib
, bitlist
, buildPythonPackage
, fe25519
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
  pname = "ge25519";
  version = "1.4.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oOvrfRSpvwfCcmpV7FOxcBOW8Ex89d2+otjORrzX4o0=";
  };

  patches = [
    # https://github.com/nthparty/ge25519/pull/1
    (fetchpatch {
      name = "relax-setuptools-dependency.patch";
      url = "https://github.com/nthparty/ge25519/commit/64de94aa67387a30905057c39729d24feaba9064.patch";
      hash = "sha256-UTT7VD4lscEA2JiGLx9CRVD1ygXgzcOWqgh5jGMS64Y=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
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
