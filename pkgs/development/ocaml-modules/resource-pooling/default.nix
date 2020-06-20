{ lib, fetchFromGitHub, buildDunePackage, lwt_log }:

buildDunePackage rec {
  version = "1.1";
  pname = "resource-pooling";

  minimumOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = pname;
    rev = version;
    sha256 = "0wsbnwszafdv3gsiiaslgf6m6pfx74h7h19i0gp2c4ivdiv3wck9";
  };

  propagatedBuildInputs = [ lwt_log ];

  doCheck = true;

  meta = {
    inherit (src.meta) homepage;
    description = "A library for pooling resources like connections, threads, or similar";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
