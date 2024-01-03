{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, atpublic
, pdm-backend
, pytestCheckHook
, sybil
}:

buildPythonPackage rec {
  pname = "flufl-i18n";
  version = "5.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "flufl_i18n";
    inherit version;
    hash = "sha256-ct6grvDeTIGJ1YuV9y/eFIilVZ/Z2RyoLKgko3CduG4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=flufl --cov-report=term --cov-report=xml" ""
  '';

  nativeBuildInputs = [ pdm-backend ];

  propagatedBuildInputs = [ atpublic ];

  pythonImportsCheck = [ "flufl.i18n" ];

  nativeCheckInputs = [
    pytestCheckHook
    sybil
  ];

  pythonNamespaces = [
    "flufl"
  ];

  meta = with lib; {
    description = "A high level API for internationalizing Python libraries and applications";
    homepage = "https://gitlab.com/warsaw/flufl.i18n";
    changelog = "https://gitlab.com/warsaw/flufl.i18n/-/raw/${version}/docs/NEWS.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
