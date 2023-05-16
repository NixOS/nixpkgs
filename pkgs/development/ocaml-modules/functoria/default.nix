{ lib, fetchurl, buildDunePackage, cmdliner
, rresult, astring, fmt, logs, bos, fpath, emile, uri
}:

buildDunePackage rec {
  pname   = "functoria";
<<<<<<< HEAD
  version = "4.3.6";

=======
  version = "4.3.4";

  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/releases/download/v${version}/mirage-${version}.tbz";
<<<<<<< HEAD
    hash = "sha256-i/5sZHfxECoKYMdGje+U21GWxJ6dDZreVcQGtbuo4SE=";
=======
    hash = "sha256-ZN8La2+N19wVo/vBUfIj17JU6FSp0jX7h2nDoIpR1XY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ cmdliner rresult astring fmt logs bos fpath emile uri ];

  doCheck = false;

  meta = with lib; {
    description = "A DSL to organize functor applications";
    homepage    = "https://github.com/mirage/functoria";
    license     = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
