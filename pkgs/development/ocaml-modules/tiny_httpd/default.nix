{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  result,
  seq,
}:

buildDunePackage rec {
  pname = "tiny_httpd";
  version = "0.16";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9L4WCduQNj5Jd/u3SozuXiGTkgojwfGIP5KgQmnWgQw=";
  };

  buildInputs = [ result ];
  propagatedBuildInputs = [ seq ];

  meta = with lib; {
    description = "Minimal HTTP server using good old threads";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "http_of_dir";
  };
}
