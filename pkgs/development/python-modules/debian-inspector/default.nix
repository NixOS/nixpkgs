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
  version = "21.5.25";

  src = fetchPypi {
    pname = "debian_inspector";
    inherit version;
    sha256 = "1d3xaqw00kav85nk29qm2yqb73bkyqf185fs1q0vgd7bnap9wqaw";
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
