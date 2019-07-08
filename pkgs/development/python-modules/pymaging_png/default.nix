{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pymaging
}:

buildPythonPackage rec {
  pname = "pymaging-png";
  version = "unstable-2016-11-16";

  src = fetchFromGitHub {
    owner = "ojii";
    repo = "pymaging-png";
    rev = "83d85c44e4b2342818e6c068065e031a9f81bb9f";
    sha256 = "1mknxvsq0lr1ffm8amzm3w2prn043c6ghqgpxlkw83r988p5fn57";
  };

  propagatedBuildInputs = [ pymaging ];

  meta = with stdenv.lib; {
    description = "Pure Python imaging library with Python 2.6, 2.7, 3.1+ support";
    homepage    = https://github.com/ojii/pymaging-png/;
    license     = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };

}
