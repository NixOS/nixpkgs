{
  lib,
  buildPythonPackage,
  fetchPypi,
  dill,
  freezegun,
  pytestCheckHook,
  python-utils,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "4.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZmLLYkiG7THrlNr2HidYO1FE68c4Ohe64Hb49PWQiPs=";
  };

  postPatch = ''
    sed -i "/-cov/d" pytest.ini
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ python-utils ];

  nativeCheckInputs = [
    dill
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "progressbar" ];

  meta = with lib; {
    description = "Text progressbar library";
    homepage = "https://progressbar-2.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
