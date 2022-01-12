{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cffi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "miniaudio";
  version = "1.46";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "irmen";
    repo = "pyminiaudio";
    rev = "v${version}";
    sha256 = "16llwmbbd9445rwhl4v66kf5zd7yl3a94zm9xyllq6ij7vnhg5jb";
  };

  propagatedNativeBuildInputs = [ cffi ];
  propagatedBuildInputs = [ cffi ];

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
