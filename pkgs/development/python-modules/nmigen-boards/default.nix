{ lib
, buildPythonPackage
, fetchFromGitHub
, nmigen
, setuptools
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "nmigen-boards";
  version = "unstable-2019-09-23";
  # python setup.py --version
  realVersion = "0.1.dev55+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "nmigen-boards";
    rev = "b8b2bbaff34c905f2b1094a74b6865961feb2290";
    sha256 = "00gsdm7qf6gsxqmkgqz1ing1yc0352s14pvw863rdbjbd1bv5r0m";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ setuptools nmigen ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "Board and connector definitions for nMigen";
    homepage = https://github.com/m-labs/nmigen-boards;
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}
