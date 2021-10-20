{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cffi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "miniaudio";
  version = "1.45";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "irmen";
    repo = "pyminiaudio";
    rev = "v${version}";
    sha256 = "1yx4n4zax103fmjzdiqzw37zibsh68b2p2l5qvgcnx2zrrjd31yl";
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
