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
  version = "21.8.27";

  src = fetchPypi {
    inherit pname version;
    sha256 = "789ee1798cd74ab4516d2e547473d69717d3b2ed7ee180ab2746e0bdfd0d88a4";
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
