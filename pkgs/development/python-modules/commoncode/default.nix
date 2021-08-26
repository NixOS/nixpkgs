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
  version = "21.7.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38511dcd7c518bf7fec4944c78e1118304f2f2582a7e6792cc5773aebe95a086";
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
