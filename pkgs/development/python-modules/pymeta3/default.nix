{ buildPythonPackage
, fetchPypi
, lib
}:
buildPythonPackage rec {
  pname = "pymeta3";
  version = "0.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "PyMeta3";
    hash = "sha256-GL2jJtmpu/WHv8DuC8loZJZNeLBnKIvPVdTZhoHQW8s=";
  };

  doCheck = false; # Tests do not support Python3

  pythonImportsCheck = [
    "pymeta"
  ];

  meta = with lib; {
    description = "Pattern-matching language based on OMeta for Python 3 and 2";
    homepage = "https://github.com/wbond/pymeta3";
    changelog = "https://github.com/wbond/pymeta3/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jfly matusf ];
  };
}
