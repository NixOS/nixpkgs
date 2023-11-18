{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonRelaxDepsHook
, html-text
, jstyleson
, lxml
, mf2py
, pyrdfa3
, rdflib
, six
, w3lib
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "extruct";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "extruct";
    rev = "v${version}";
    hash = "sha256-hf6b/tZLggHzgFmZ6aldZIBd17Ni7vCTIIzhNlyjvxw=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  # rdflib-jsonld functionality is part of rdblib from version 6 onwards
  pythonRemoveDeps = [
    "rdflib-jsonld"
  ];

  propagatedBuildInputs = [
    html-text
    jstyleson
    lxml
    mf2py
    pyrdfa3
    rdflib
    six
    w3lib
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "extruct" ];

  meta = with lib; {
    description = "Extract embedded metadata from HTML markup";
    homepage = "https://github.com/scrapinghub/extruct";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ambroisie ];
  };
}
