{ stdenv, buildPythonPackage, fetchFromGitHub, requests }:

buildPythonPackage rec {
  pname   = "httmock";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "patrys";
    repo = "httmock";
    rev = version;
    sha256 = "0iya8qsb2jm03s9p6sf1yzgm1irxl3dcq0k0a9ygl0skzjz5pvab";
  };

  checkInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "A mocking library for requests";
    homepage    = https://github.com/patrys/httmock;
    license     = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
