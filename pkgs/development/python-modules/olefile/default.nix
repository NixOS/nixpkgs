{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "olefile";
  version = "0.47";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-WZODOBoL89+9kyygymUVrNF07UiHDL9/7hI9aYwZLBw=";
  };

  nativeCheckInputs = [
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
