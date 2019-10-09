{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytz
, unittest2
}:

buildPythonPackage rec {
  pname = "ciso8601";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "closeio";
    repo = "ciso8601";
    rev = "v${version}";
    sha256 = "143b6mqhjnggvcd0wwbaj6k5g9820whx2q94145cb5bqgwq1lc5m";
  };

  propagatedBuildInputs = [ pytz ];

  checkInputs = [ pytz ]
   ++ lib.optional isPy27 unittest2;

  meta = with lib; {
    description = "Fast ISO8601 date time parser for Python written in C";
    homepage = https://github.com/closeio/ciso8601;
    license = licenses.mit;
    maintainers = with maintainers; [ liamdiprose ];
  };

}
