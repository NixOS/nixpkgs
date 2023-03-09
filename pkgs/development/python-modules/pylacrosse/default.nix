{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, nose
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylacrosse";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-lacrosse";
    rev = version;
    sha256 = "0g5hqm8lq0gsnvhcydjk54rjf7lpxzph8k7w1nnvnqfbhf31xfcf";
  };

  propagatedBuildInputs = [ pyserial ];

  nativeCheckInputs = [
    mock
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylacrosse" ];

  meta = with lib; {
    description = "Python library for Jeelink LaCrosse";
    homepage = "https://github.com/hthiery/python-lacrosse";
    license = with licenses; [ lgpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
