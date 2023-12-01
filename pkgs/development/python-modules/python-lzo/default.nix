{ lib, fetchPypi, buildPythonPackage, lzo, pytestCheckHook, setuptools, wheel }:

buildPythonPackage rec {
  pname = "python-lzo";
  version = "1.15";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pXqqAMXDoFFd2fdCa6LPYBdn3BncAj2LmdShOwoye0k=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  buildInputs = [ lzo ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "lzo"
  ];

  meta = with lib; {
    homepage = "https://github.com/jd-boyd/python-lzo";
    description = "Python bindings for the LZO data compression library";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.jbedo ];
  };
}
