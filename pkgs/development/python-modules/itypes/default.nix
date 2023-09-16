{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "itypes";
  version = "1.2.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "tomchristie";
    rev = version;
    sha256 = "1ljhjp9pacbrv2phs58vppz1dlxix01p98kfhyclvbml6dgjcr52";
  };

  pytestFlagsArray = [ "tests.py" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Simple immutable types for python";
    homepage = "https://github.com/tomchristie/itypes";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
