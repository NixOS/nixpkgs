{ lib
, buildPythonPackage
, cryptography
, fetchpatch
, fetchPypi
, pyopenssl
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iTHa84+KTIUnSg6LfLJa3f2NHyj5+4++0FPdUa7HXck=";
  };

  patches = [
    # https://github.com/certbot/josepy/pull/158
    (fetchpatch {
      name = "fix-setuptools-deprecation.patch";
      url = "https://github.com/certbot/josepy/commit/8f1b4b57a29a868a87fd6eee19a67a7ebfc07ea1.patch";
      hash = "sha256-9d+Bk/G4CJXpnjJU0YkXLsg0G3tPxR8YN2niqriQQkI=";
      includes = [ "tests/test_util.py" ];
    })
  ];

  propagatedBuildInputs = [
    pyopenssl
    cryptography
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --flake8 --cov-report xml --cov-report=term-missing --cov=josepy --cov-config .coveragerc" ""
    sed -i '/flake8-ignore/d' pytest.ini
  '';

  pythonImportsCheck = [
    "josepy"
  ];

  meta = with lib; {
    description = "JOSE protocol implementation in Python";
    homepage = "https://github.com/jezdez/josepy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
