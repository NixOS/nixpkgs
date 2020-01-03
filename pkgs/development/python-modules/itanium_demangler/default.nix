{ buildPythonPackage
, fetchFromGitHub
, lib
, pytest
}:

buildPythonPackage rec {
  pname = "itanium_demangler";
  version = "1.0"; # pulled from pypi version

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "python-${pname}";
    rev = "29c77860be48e6dafe3496e4d9d0963ce414e366";
    sha256 = "0qm95l6542nk63986w9lgzkxg824l31714i584s02rh9xwfg1xfx";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests/test.py
  '';

  meta = with lib; {
    description = "A pure Python parser for the Itanium C++ ABI symbol mangling language";
    homepage = "https://github.com/whitequark/python-itanium_demangler";
    license = licenses.bsd0;
    maintainers = [ maintainers.pamplemousse ];
  };
}
