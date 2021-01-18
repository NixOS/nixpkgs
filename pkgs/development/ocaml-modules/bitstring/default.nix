{ lib, fetchFromGitHub, buildDunePackage, stdlib-shims }:

buildDunePackage rec {
  pname = "bitstring";
  version = "4.0.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "xguerin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z7jmgljvp52lvn3ml2cp6gssxqp4sikwyjf6ym97cycbcw0fjjm";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  meta = with lib; {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = "https://github.com/xguerin/bitstring";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.maurer ];
  };
}
