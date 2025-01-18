{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppxlib,
}:

buildDunePackage rec {
  pname = "ocsigen-ppx-rpc";
  version = "1.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = pname;
    rev = version;
    sha256 = "sha256:0qgasd89ayamgl2rfyxsipznmwa3pjllkyq9qg0g1f41h8ixpsfh";
  };

  propagatedBuildInputs = [ ppxlib ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Syntax for RPCs for Eliom and Ocsigen Start";
    license = licenses.lgpl21Only;
    maintainers = [ maintainers.vbgl ];
  };

}
