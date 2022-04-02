{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "pyvlx";
  version = "0.2.20";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Julius2342";
    repo = pname;
    rev = version;
    sha256 = "1irjix9kr6qih84gii7k1a9c67n8133gpnmwfd09550jsqdmg006";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyvlx"
  ];

  meta = with lib; {
    description = "Python client to work with Velux units";
    longDescription = ''
      PyVLX uses the Velux KLF 200 interface to control io-Homecontrol
      devices, e.g. Velux Windows.
    '';
    homepage = "https://github.com/Julius2342/pyvlx";
    license = with licenses; [ lgpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
