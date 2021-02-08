{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pkce";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "RomeoDespres";
    repo = pname;
    rev = version;
    sha256 = "15fzpp3b5qmj27hpgnwkzjwllgwwdfccizz8ydmliakm2hdr1xpn";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pkce" ];

  meta = with lib; {
    description = "Python module to work with PKCE";
    homepage = "https://github.com/RomeoDespres/pkce";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
