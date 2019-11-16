{ lib, buildDunePackage, fetchFromGitHub, cppo }:

buildDunePackage rec {
  pname = "merlin-extend";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = pname;
    sha256 = "1dxiqmm7ry24gvw6p9n4mrz37mnq4s6m8blrccsv3rb8yq82acx9";
    rev = "v${version}";
  };

  buildInputs = [ cppo ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "SDK to extend Merlin";
    license = licenses.mit;
    maintainers = [ maintainers.volth ];
  };
}
