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
  version = "8.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hFjXsSh8X7EoyQ4jOBz5nc3nS+r2x/9jhM6E1v4JCts=";
  };

  postPatch = ''
    substituteInPlace src/click/_unicodefun.py \
      --replace '"locale"' "'${locale}/bin/locale'"
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
