{ lib, fetchFromGitHub, buildDunePackage
, yojson, xmlm, lwt, lwt_react, ocurl, sha
, ounit2, gnupg, unzip
, ... ## 0install-solver
}@inputs:

buildDunePackage rec {
  pname = "0install";
  version = "2.18";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "0install";
    repo = "0install";
    rev = "v${version}";
    sha256 = "sha256-CxADWMYZBPobs65jeyMQjqu3zmm2PgtNgI/jUsYUp8I=";
  };

  propagatedBuildInputs = [
    inputs."0install-solver"
    yojson
    xmlm
    lwt
    lwt_react
    ocurl
    sha
  ];

  ## REVIEW: Can't get tests to work; it seems some tests try to access `/build`
  ## and then fail with a Unix error EPERM.
  doCheck = false;
  checkInputs = [ ounit2 ];
  nativeCheckInputs = [ gnupg unzip ];

  meta = {
    description = "Decentralised installation system";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.niols ];
    homepage = "https://github.com/0install/0install";
  };
}
