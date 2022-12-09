{ lib, fetchFromGitHub, buildDunePackage, ssl, lwt }:

buildDunePackage rec {
  pname = "lwt_ssl";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "lwt_ssl";
    rev = version;
    sha256 = "sha256-d/jkTI/D2LVi9nrndRGgqg6ca1FcmRKknR7YXyA7gWw=";
  };

  propagatedBuildInputs = [ ssl lwt ];

  meta = {
    homepage = "https://github.com/aantron/lwt_ssl";
    description = "OpenSSL binding with concurrent I/O";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
