{ lib
, buildPythonPackage
, fetchPypi
, zetup
, six
, moretools
, pathpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "modeled";
  version = "0.1.8";

  src = fetchPypi {
    extension = "zip";
    inherit pname version;
    sha256 = "1wcl3r02q10gxy4xw7g8x2wg2sx4sbawzbfcl7a5xdydrxl4r4v4";
  };

  buildInputs = [ zetup ];

  propagatedBuildInputs = [ six moretools pathpy ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Universal data modeling for Python";
    homepage = "https://bitbucket.org/userzimmermann/python-modeled";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.costrouc ];
  };
}
