{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  pythonOlder,

  # build-system
  setuptools,

  # tests
  freezegun,
  pytestCheckHook,
  pytz,
  tzdata,
}:

buildPythonPackage rec {
  pname = "babel";
  version = "2.14.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Babel";
    inherit version;
    hash = "sha256-aRmGfbA2OYuiHrXHoPayirjLw656c6ROvjSudKTn02M=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
    # https://github.com/python-babel/babel/issues/988#issuecomment-1521765563
    pytz
  ] ++ lib.optionals isPyPy [ tzdata ];

  disabledTests = [
    # fails on days switching from and to daylight saving time in EST
    # https://github.com/python-babel/babel/issues/988
    "test_format_time"
  ];

  pythonImportsCheck = [ "babel" ];

  meta = {
    description = "Collection of internationalizing tools";
    homepage = "https://babel.pocoo.org/";
    changelog = "https://github.com/python-babel/babel/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "pybabel";
  };
}
