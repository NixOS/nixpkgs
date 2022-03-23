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
  version = "8.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QQ6TKwUPXu13PEzalN51lxyJzbMVWnKggxE5p55ey1s=";
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
