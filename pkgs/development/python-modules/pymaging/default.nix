{ stdenv
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pymaging";
  version = "unstable-2016-11-16";

  src = fetchFromGitHub {
    owner = "ojii";
    repo = "pymaging";
    rev = "596a08fce5664e58d6e8c96847393fbe987783f2";
    sha256 = "18g3n7kfrark30l4vzykh0gdbnfv5wb1zvvjbs17sj6yampypn38";
  };

  meta = with stdenv.lib; {
    description = "Pure Python imaging library with Python 2.6, 2.7, 3.1+ support";
    homepage    = http://pymaging.rtfd.org;
    license     = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };

}
