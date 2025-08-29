{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  stdlib-shims,
}:

buildDunePackage rec {
  pname = "bitstring";
  version = "5.0.1";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "xguerin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gnp0Ypjo45cD6OGs+U6cr1TfM4kFEmw9fFNEa0BIZ/I=";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  meta = with lib; {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = "https://github.com/xguerin/bitstring";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.maurer ];
  };
}
