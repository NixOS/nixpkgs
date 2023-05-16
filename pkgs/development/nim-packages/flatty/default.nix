{ lib, buildNimPackage, fetchFromGitHub }:

<<<<<<< HEAD
buildNimPackage (final: prev: {
=======
buildNimPackage rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "flatty";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "treeform";
<<<<<<< HEAD
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
=======
    repo = pname;
    rev = version;
    hash = "sha256-ZmhjehmEJHm5qNlsGQvyYLajUdwhWt1+AtRppRrNtgA=";
  };

  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "Tools and serializer for plain flat binary files";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
