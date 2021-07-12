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
  version = "21.6.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6c8c985746a541913d5bb534c770f2422e5b4ac7a4ef765abc05c287a40ff4b";
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
