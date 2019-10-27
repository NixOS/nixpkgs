{ stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "planarity";
  version = "3.0.0.5";

  src = fetchFromGitHub {
    owner = "graph-algorithms";
    repo = "edge-addition-planarity-suite";
    rev = "Version_${version}";
    sha256 = "01cm7ay1njkfsdnmnvh5zwc7wg7x189hq1vbfhh9p3ihrbnmqzh8";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  doCheck = true;

  patches = [
    # declare variables declared in headers as extern, not yet merged upstream
    (fetchpatch {
      url = "https://github.com/graph-algorithms/edge-addition-planarity-suite/pull/3.patch";
      sha256 = "1nqjc4clr326imz4jxqxcxv2hgh1sjgzll27k5cwkdin8lnmmil8";
    })
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/graph-algorithms/edge-addition-planarity-suite;
    description = "A library for implementing graph algorithms";
    license = licenses.bsd3;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.unix;
  };
}
