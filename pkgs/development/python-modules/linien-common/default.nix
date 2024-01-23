{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, importlib-metadata
, numpy
, rpyc
, scipy
, appdirs
, callPackage
}:

buildPythonPackage rec {
  pname = "linien-common";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linien-org";
    repo = "linien";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZgAp1SEiHijyjK74VZyRLYY3Hzfc3BQ6cnoO3hZzvbE=";
  };

  sourceRoot = "source/linien-common";

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    importlib-metadata
    numpy
    rpyc
    scipy
    appdirs
  ];

  # Temporarily fix rpyc version requirement before upstream switch to latest
  # See: https://github.com/linien-org/pyrp3/pull/10#pullrequestreview-1585887668
  preConfigure = ''
    substituteInPlace setup.py \
      --replace "rpyc>=4.0,<5.0" "rpyc"
  '';

  pythonImportsCheck = [ "linien_common" ];

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Shared components of the Linien spectroscopy lock application";
    homepage = "https://github.com/linien-org/linien/tree/develop/linien-common";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fsagbuya doronbehar ];
  };
}
