{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cffi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "miniaudio";
  version = "1.44";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "irmen";
    repo = "pyminiaudio";
    rev = "v${version}";
    sha256 = "1na3vx10lc41gkk14h6s3fm4bnrd2bwf4qbf1l6bfvhs92b9k111";
  };

  propagatedBuildInputs = [
    cffi
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "miniaudio" ];

  meta = with lib; {
    description = "Python bindings for the miniaudio library and its decoders";
    homepage = "https://github.com/irmen/pyminiaudio";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
