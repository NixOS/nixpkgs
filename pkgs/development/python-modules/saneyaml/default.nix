{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, pyyaml
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "saneyaml";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6074f1959041342ab41d74a6f904720ffbcf63c94467858e0e22e17e3c43d41";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "saneyaml"
  ];

  meta = with lib; {
    description = "A PyYaml wrapper with sane behaviour to read and write readable YAML safely";
    homepage = "https://github.com/nexB/saneyaml";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
