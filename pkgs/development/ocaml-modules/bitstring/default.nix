{ stdenv, fetchFromGitHub, buildDunePackage, ppx_tools_versioned, ounit }:

buildDunePackage rec {
  pname = "bitstring";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "xguerin";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r49qax7as48jgknzaq6p9rbpmrvnmlic713wzz5bj60j5h0396f";
  };

  buildInputs = [ ppx_tools_versioned ounit ];
  doCheck = true;

  meta = with stdenv.lib; {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = https://github.com/xguerin/bitstring;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.maurer ];
  };
}
