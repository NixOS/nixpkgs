{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage (final: prev: {
  pname = "flatty";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "treeform";
    repo = "flatty";
    rev = final.version;
    hash = "sha256-ZmhjehmEJHm5qNlsGQvyYLajUdwhWt1+AtRppRrNtgA=";
  };

  doCheck = false; # tests fail with Nim-2.0.0

  meta = final.src.meta // {
    description = "Tools and serializer for plain flat binary files";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.ehmry ];
  };
})
