{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, numpy }:

buildPythonPackage rec {
  pname = "jsonconversion";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G/qnKkcdugqSVKu6naqNKzDpMnuOASmScyra4rwd884=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner'" ""
  '';

  nativeCheckInputs = [ pytestCheckHook numpy ];

  pythonImportsCheck = [ "jsonconversion" ];

  meta = with lib; {
    description = "This python module helps converting arbitrary Python objects into JSON strings and back";
    homepage = "https://pypi.org/project/jsonconversion/";
    license = licenses.bsd2;
    maintainers = [ maintainers.terlar ];
  };
}
