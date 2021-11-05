{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, importlib-metadata
, locale
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click";
  version = "8.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7027bc7bbafaab8b2c2816861d8eb372429ee3c02e193fc2f93d6c4ab9de49c5";
  };

  postPatch = ''
    substituteInPlace src/click/_unicodefun.py \
      --replace "'locale'" "'${locale}/bin/locale'"
  '';

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://click.palletsprojects.com/";
    description = "Create beautiful command line interfaces in Python";
    longDescription = ''
      A Python package for creating beautiful command line interfaces in a
      composable way, with as little code as necessary.
    '';
    license = licenses.bsd3;
  };
}
