{ lib
, fetchFromGitHub
, buildDunePackage
, ppx_cstruct
, cstruct
, re
, ppx_tools
}:

buildDunePackage rec {
  pname = "tar";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-tar";
    rev = "v${version}";
    sha256 = "14k24vn3q5jl0iyrynb5vwg80670qsv12fsmc6cdgh4zwdpjh7zs";
  };

  useDune2 = true;

  propagatedBuildInputs = [
    ppx_cstruct
    cstruct
    re
  ];

  buildInputs = [
    ppx_tools
  ];

  doCheck = true;

  meta = {
    description = "Decode and encode tar format files from Unix";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
