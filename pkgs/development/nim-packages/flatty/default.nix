{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "flatty";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "treeform";
    repo = pname;
    rev = version;
    hash = "sha256-ZmhjehmEJHm5qNlsGQvyYLajUdwhWt1+AtRppRrNtgA=";
  };


  meta = with lib;
    src.meta // {
      description = "Tools and serializer for plain flat binary files";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
