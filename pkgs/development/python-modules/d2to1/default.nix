{ buildPythonPackage
, lib
, fetchFromGitHub
, nose
}:
buildPythonPackage rec {
  pname = "d2to1";
  version = "0.2.12";

  checkInputs = [ nose ];

  src = fetchFromGitHub {
    owner = "embray";
    repo = pname;
    rev = version;
    sha256 = "1q04ab8vjvx7fmq9ckkl8r9hlwwbqiyjbzaa4v1mv5zicfssxwsi";
  };

  meta = with lib;{
    description = "Support for distutils2-like setup.cfg files as package metadata";
    homepage = https://github.com/embray/d2to1;
    license = licenses.bsd2;
    maintainers = with maintainers; [ makefu ];
  };
}
