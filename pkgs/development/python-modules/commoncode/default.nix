{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, click
, requests
, attrs
, intbitset
, saneyaml
, text-unidecode
, beautifulsoup4
, pytestCheckHook
, pytest-xdist
}:
buildPythonPackage rec {
  pname = "commoncode";
  version = "21.8.31";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e74c61226834393801e921ab125eae3b52361340278fb9a468c5c691d286c32";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
    requests
    attrs
    intbitset
    saneyaml
    text-unidecode
    beautifulsoup4
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [
    "commoncode"
  ];

  meta = with lib; {
    description = "A set of common utilities, originally split from ScanCode";
    homepage = "https://github.com/nexB/commoncode";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
