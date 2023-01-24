{ lib, fetchFromGitHub, buildDunePackage
, lwt, lwt_ppx, stringext
, alcotest }:

buildDunePackage rec {
  pname = "multipart-form-data";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "cryptosense";
    repo = pname;
    rev = version;
    hash = "sha256-3MYJDvVbPIv/JDiB9nKcLRFC5Qa0afyEfz7hk8MWRII=";
  };

  nativeBuildInputs = [ lwt_ppx ];
  propagatedBuildInputs = [ lwt stringext ];

  duneVersion = "3";

  doCheck = true;
  nativeCheckInputs = [ alcotest ];

  meta = {
    description = "Parser for multipart/form-data (RFC2388)";
    homepage = "https://github.com/cryptosense/multipart-form-data";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
