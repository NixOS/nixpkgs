{ lib, buildDunePackage, fetchFromGitHub, m4, core_kernel, ounit }:

buildDunePackage rec {
  pname = "cfstream";
  version = "1.3.1";

  useDune2 = true;

  minimumOCamlVersion = "4.04.1";

  src = fetchFromGitHub {
    owner = "biocaml";
    repo   = pname;
    rev    = version;
    sha256 = "0qnxfp6y294gjsccx7ksvwn9x5q20hi8sg24rjypzsdkmlphgdnd";
  };

  patches = [ ./git_commit.patch ];

  # This currently fails with dune
  strictDeps = false;

  nativeBuildInputs = [ m4 ];
  nativeCheckInputs = [ ounit ];
  propagatedBuildInputs = [ core_kernel ];

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Simple Core-inspired wrapper for standard library Stream module";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl21;
  };
}
