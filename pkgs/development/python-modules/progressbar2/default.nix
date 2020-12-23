{ stdenv
, python
, buildPythonPackage
, fetchPypi
, python-utils
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "3.53.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef72be284e7f2b61ac0894b44165926f13f5d995b2bf3cd8a8dedc6224b255a7";
  };

  propagatedBuildInputs = [ python-utils ];

  # depends on unmaintained pytest-pep8
  # https://github.com/WoLpH/python-progressbar/issues/241
  doCheck = false;

  pythonImportsCheck = [ "progressbar" ];

  meta = with stdenv.lib; {
    homepage = "https://progressbar-2.readthedocs.io/en/latest/";
    description = "Text progressbar library for python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman turion ];
  };
}
