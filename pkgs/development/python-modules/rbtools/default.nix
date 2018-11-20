{ stdenv
, buildPythonPackage
, fetchurl
, nose
, six
, isPy3k
}:

buildPythonPackage rec {
  pname = "rbtools";
  version = "0.7.2";
  disabled = isPy3k;

  src = fetchurl {
    url = "http://downloads.reviewboard.org/releases/RBTools/0.7/RBTools-0.7.2.tar.gz";
    sha256 = "1ng8l8cx81cz23ls7fq9wz4ijs0zbbaqh4kj0mj6plzcqcf8na4i";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = https://www.reviewboard.org/docs/rbtools/dev/;
    description = "RBTools is a set of command line tools for working with Review Board and RBCommons";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };

}
