{ lib
, buildPythonPackage
, fetchPypi
, boltons
, attrs
, face
, pytestCheckHook
, pyyaml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "glom";
  version = "20.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VAUQcrzMnNs+u9ivBVkZUTemHTCPBL/xlnjkthNQ6xI=";
  };

  propagatedBuildInputs = [
    boltons
    attrs
    face
  ];

  checkInputs = [
    pytestCheckHook
    pyyaml
  ];

  preCheck = ''
    # test_cli.py checks the output of running "glom"
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # Test is outdated (was made for PyYAML 3.x)
    "test_main_yaml_target"
  ];

  pythonImportsCheck = [
    "glom"
  ];

  meta = with lib; {
    homepage = "https://github.com/mahmoud/glom";
    description = "Restructuring data, the Python way";
    longDescription = ''
      glom helps pull together objects from other objects in a
      declarative, dynamic, and downright simple way.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ twey ];
  };
}
