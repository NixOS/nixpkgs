{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pyyaml
}:

buildPythonPackage rec {
  pname = "pyvlx";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "Julius2342";
    repo = pname;
    rev = version;
    sha256 = "031gp3sjagvmgdhfpdqlawva425ja1n3bmxk6jyn4zx54szj9zwf";
  };

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyvlx" ];

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
