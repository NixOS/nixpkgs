{ lib
, buildPythonPackage
, fetchPypi
, moretools
, path
, pytestCheckHook
, pythonOlder
, six
, zetup
}:

buildPythonPackage rec {
  pname = "modeled";
  version = "0.1.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    extension = "zip";
    inherit pname version;
    sha256 = "1wcl3r02q10gxy4xw7g8x2wg2sx4sbawzbfcl7a5xdydrxl4r4v4";
  };

  buildInputs = [
    zetup
  ];

  propagatedBuildInputs = [
    moretools
    path
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # path.py was renamed to path
    substituteInPlace requirements.txt \
      --replace "path.py" "path"
    # Issue with module name detection (path.py)
    substituteInPlace modeled/__init__.py  \
      --replace "__import__('zetup').annotate(__name__)" ""
  '';

  pythonImportsCheck = [
    "modeled"
  ];

  meta = with lib; {
    description = "Universal data modeling for Python";
    homepage = "https://github.com/modeled/modeled";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ costrouc ];
  };
}
