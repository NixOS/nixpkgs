{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  m4,
  camlp-streams,
  core_kernel,
  ounit,
}:

buildDunePackage rec {
  pname = "cfstream";
  version = "1.3.2";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "biocaml";
    repo = pname;
    rev = version;
    hash = "sha256-iSg0QsTcU0MT/Cletl+hW6bKyH0jkp7Jixqu8H59UmQ=";
  };

  patches = [
    ./git_commit.patch
    ./janestreet-0.17.patch
  ];

  nativeBuildInputs = [ m4 ];
  checkInputs = [ ounit ];
  propagatedBuildInputs = [
    camlp-streams
    core_kernel
  ];

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Simple Core-inspired wrapper for standard library Stream module";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl21;
  };
}
