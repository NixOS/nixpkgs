{ stdenv, fetchFromGitHub, buildDunePackage, ppx_tools_versioned, ounit }:

buildDunePackage rec {
  pname = "bitstring";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "xguerin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ys8xx174jf8v5sm0lbxvzhdlcs5p0fhy1gvf58gad2g4gvgpvxc";
  };

  buildInputs = [ ppx_tools_versioned ounit ];
  doCheck = true;

  meta = with stdenv.lib; {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = "https://github.com/xguerin/bitstring";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.maurer ];
  };
}
