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
  version = "21.1.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e2daa34fac2d91307b23d9df5f01a6168fdffb12bf5d161bd6776bade29b479";
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
