{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "x11";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = pname;
    rev = "2093a4c01360cbb5dd33ab79fd4056e148b53ca1";
    hash = "sha256-2XRyXiBxAc9Zx/w0zRBHRZ240qww0FJvIvOKZ8YH50A=";
  };

  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "X11 library for nim";
      license = [ licenses.mit ];
      maintainers = [ maintainers.marcusramberg ];
    };
}
