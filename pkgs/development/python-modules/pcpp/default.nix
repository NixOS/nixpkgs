{ buildPythonPackage
, fetchFromGitHub
, stdenv
}:

buildPythonPackage rec {
  pname = "pcpp";
  version = "1.21";

  src = fetchFromGitHub {
    owner = "ned14";
    repo = "pcpp";
    rev = "v${version}";
    sha256 = "0k52qyxzdngdhyn4sya2qn1w1a4ll0mcla4h4gb1v91fk4lw25dm";
    fetchSubmodules = true;
  };
 
  meta = with stdenv.lib; {
    homepage = https://github.com/ned14/pcpp;
    description = "A C99 preprocessor written in pure Python";
    license = licenses.bsd0;
    maintainers = with maintainers; [ rakesh4g ];
 };
}
