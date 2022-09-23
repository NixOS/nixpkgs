{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "olefile";
  version = "0.46";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "133b031eaf8fd2c9399b78b8bc5b8fcbe4c31e85295749bb17a87cba8f3c3964";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "olefile"
  ];

  meta = with lib; {
    description = "Python package to parse, read and write Microsoft OLE2 files";
    homepage = "https://www.decalage.info/python/olefileio";
    # BSD2 + reference to Pillow
    # http://olefile.readthedocs.io/en/latest/License.html
    license = with licenses; [ bsd2 /* and */ hpnd ];
    maintainers = with maintainers; [ fab ];
  };
}
