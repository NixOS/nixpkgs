{ lib
, buildPythonPackage
, fetchFromGitHub
, nmigen
, setuptools
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "nmigen-boards";
  version = "unstable-2019-10-13";
  # python setup.py --version
  realVersion = "0.1.dev79+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "nmigen-boards";
    rev = "835c175d7cf9d143aea2c7dbc0c870ede655cfc2";
    sha256 = "1mbxgfv6k9i3668lr1b3hrvial2vznvgn4ckjzc36hhizp47ypzw";
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
