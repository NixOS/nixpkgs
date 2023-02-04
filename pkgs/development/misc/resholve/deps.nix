{ lib
, callPackage
, fetchFromGitHub
, python27
, ...
}:

/*
  Notes on specific dependencies:
  - if/when python2.7 is removed from nixpkgs, this may need to figure
  out how to build oil's vendored python2
  - I'm not sure if glibcLocales is worth the addition here. It's to fix
  a libc test oil runs. My oil fork just disabled the libc tests, but
  I haven't quite decided if that's the right long-term call, so I
  didn't add a patch for it here yet.
*/

rec {
  # binlore = callPackage ./binlore.nix { };
  oil = callPackage ./oildev.nix {
    inherit python27;
    inherit six;
    inherit typing;
  };
  configargparse = python27.pkgs.buildPythonPackage rec {
    pname = "configargparse";
    version = "1.5.3";

    src = fetchFromGitHub {
      owner = "bw2";
      repo = "ConfigArgParse";
      rev = "v${version}";
      sha256 = "1dsai4bilkp2biy9swfdx2z0k4akw4lpvx12flmk00r80hzgbglz";
    };

    doCheck = false;

    pythonImportsCheck = [ "configargparse" ];

    meta = with lib; {
      description = "A drop-in replacement for argparse";
      homepage = "https://github.com/bw2/ConfigArgParse";
      license = licenses.mit;
    };
  };
  six = python27.pkgs.buildPythonPackage rec {
    pname = "six";
    version = "1.16.0";

    src = python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926";
    };

    doCheck = false;

    meta = {
      description = "A Python 2 and 3 compatibility library";
      homepage = "https://pypi.python.org/pypi/six/";
      license = lib.licenses.mit;
    };
  };
  typing = python27.pkgs.buildPythonPackage rec {
    pname = "typing";
    version = "3.10.0.0";

    src = python27.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "13b4ad211f54ddbf93e5901a9967b1e07720c1d1b78d596ac6a439641aa1b130";
    };

    doCheck = false;

    meta = with lib; {
      description = "Backport of typing module to Python versions older than 3.5";
      homepage = "https://docs.python.org/3/library/typing.html";
      license = licenses.psfl;
    };
  };
}
