{ lib, fetchFromGitHub, buildDunePackage, stdlib-shims }:

buildDunePackage rec {
  pname = "bitstring";
  version = "4.1.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "xguerin";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mghsl8b2zd2676mh1r9142hymhvzy9cw8kgkjmirxkn56wbf56b";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  meta = with lib; {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = "https://github.com/xguerin/bitstring";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.maurer ];
  };
}
