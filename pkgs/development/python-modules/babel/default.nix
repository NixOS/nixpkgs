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
  glibcLocales,
  pytestCheckHook,
  pytz,
  tzdata,
}:

buildPythonPackage rec {
  pname = "babel";
  version = "2.17.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DFTP+xn2kM3MUqO1C8v3HgeoCNHIDVSfJFm50s8K+50=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    freezegun
    glibcLocales
    pytestCheckHook
    # https://github.com/python-babel/babel/issues/988#issuecomment-1521765563
    pytz
  ]
  ++ lib.optionals isPyPy [ tzdata ];

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
