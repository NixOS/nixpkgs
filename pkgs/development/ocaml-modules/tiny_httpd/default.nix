{ lib, buildDunePackage, fetchFromGitHub
, result
, seq
}:

buildDunePackage rec {
  pname = "tiny_httpd";
  version = "0.12";

  minimalOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:1z9hzc0ib7pg9fsjmpggjqwrnip57izr2v0na7vc7s25lxsiag6a";
  };

  buildInputs = [ result ];
  propagatedBuildInputs = [ seq ];

  meta = {
    description = "Minimal HTTP server using good old threads";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
