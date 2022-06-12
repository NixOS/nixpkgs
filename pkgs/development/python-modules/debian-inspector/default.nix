{ lib
, buildPythonPackage
, fetchPypi
, chardet
, attrs
, commoncode
, pytestCheckHook
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "debian-inspector";
  version = "30.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "debian_inspector";
    inherit version;
    hash = "sha256-0PT5sT6adaqgYQtWjks12ys0z1C3n116aeJaEKR/Wxg=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    chardet
    attrs
    commoncode
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "debian_inspector"
  ];

  meta = with lib; {
    description = "Utilities to parse Debian package, copyright and control files";
    homepage = "https://github.com/nexB/debian-inspector";
    license = with licenses; [ asl20 bsd3 mit ];
    maintainers = teams.determinatesystems.members;
  };
}
