{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "pychannels";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "fancybits";
    repo = pname;
    rev = version;
    sha256 = "0dqc0vhf6c5r3g7nfbpa668x6z2zxrznk6h907s6sxkq4sbqnhqf";
  };

  propagatedBuildInputs = [ requests ];

  # Project has not published tests yet
  doCheck = false;
  pythonImportsCheck = [ "pychannels" ];

  meta = with lib; {
    description = "Python library for interacting with the Channels app";
    homepage = "https://github.com/fancybits/pychannels";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
