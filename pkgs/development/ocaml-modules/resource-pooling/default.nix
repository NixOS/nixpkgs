{ lib, fetchFromGitHub, buildDunePackage, lwt_log }:

buildDunePackage rec {
  version = "1.2";
  pname = "resource-pooling";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = pname;
    rev = version;
    sha256 = "sha256-GNYPxjMTo7y40y7aQdseuFyeVF/hSCZKXfEaH/WIO9w=";
  };

  propagatedBuildInputs = [ lwt_log ];

  doCheck = true;

  meta = {
    inherit (src.meta) homepage;
    description = "Library for pooling resources like connections, threads, or similar";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
