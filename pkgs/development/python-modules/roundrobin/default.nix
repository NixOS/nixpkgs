{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "roundrobin";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "linnik";
    repo = pname;
    rev = version;
    hash = "sha256-eedE4PE43sbJE/Ktrc31KjVdfqe2ChKCYUNIl7fir0E=";
  };

  meta = with lib; {
    description = "This is rather small collection of round robin utilites";
    homepage = "https://github.com/linnik/roundrobin";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim ];
  };
}
