{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, flake8
, orderedmultidict
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "furl";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08dnw3bs1mk0f1ccn466a5a7fi1ivwrp0jspav9arqpf3wd27q60";
  };

  patches = [
    (fetchpatch {
      name = "tests_overcome_bpo42967.patch";
      url = "https://github.com/gruns/furl/files/6030371/tests_overcome_bpo42967.patch.txt";
      sha256 = "1l0lxmcp9x73kxy0ky2bh7zxa4n1cf1qxyyax97n90d1s3dc7k2q";
    })
  ];

  propagatedBuildInputs = [
    orderedmultidict
    six
  ];

  checkInputs = [
    flake8
    pytestCheckHook
  ];

  disabledTests = [
     # see https://github.com/gruns/furl/issues/121
    "join"
  ];

  pythonImportsCheck = [ "furl" ];

  meta = with lib; {
    description = "Python library that makes parsing and manipulating URLs easy";
    homepage = "https://github.com/gruns/furl";
    license = licenses.unlicense;
    maintainers = with maintainers; [ vanzef ];
  };
}
