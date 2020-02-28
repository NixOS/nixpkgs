{ stdenv, buildDunePackage, fetchFromGitHub, m4, core_kernel, ounit }:

buildDunePackage rec {
  pname = "cfstream";
  version = "1.3.1";

  minimumOCamlVersion = "4.04.1";

  src = fetchFromGitHub {
    owner = "biocaml";
    repo   = pname;
    rev    = version;
    sha256 = "0qnxfp6y294gjsccx7ksvwn9x5q20hi8sg24rjypzsdkmlphgdnd";
  };

  patches = [ ./git_commit.patch ];

  buildInputs = [ m4 ];
  checkInputs = [ ounit ];
  propagatedBuildInputs = [ core_kernel ];

  doCheck = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Simple Core-inspired wrapper for standard library Stream module";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl21;
  };
}
