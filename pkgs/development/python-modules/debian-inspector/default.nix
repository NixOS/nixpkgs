{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, chardet
, attrs
, commoncode
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "debian-inspector";
  version = "30.0.0";

  src = fetchPypi {
    pname = "debian_inspector";
    inherit version;
    sha256 = "sha256-0PT5sT6adaqgYQtWjks12ys0z1C3n116aeJaEKR/Wxg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  dontConfigure = true;

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
