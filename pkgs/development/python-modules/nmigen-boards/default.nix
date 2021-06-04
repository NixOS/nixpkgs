{ lib
, buildPythonPackage
, fetchFromGitHub
, nmigen
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "nmigen-boards";
  version = "unstable-2021-02-09";
  # python setup.py --version
  realVersion = "0.1.dev173+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "nmigen";
    repo = "nmigen-boards";
    rev = "a35d870a994c2919116b2c06166dc127febb1512";
    sha256 = "1flbcyb2xz174dgqv2964qra80xj2vbzbqwjb27shvxm6knj9ikf";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ setuptools nmigen ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Board and connector definitions for nMigen";
    homepage = "https://github.com/nmigen/nmigen-boards";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily ];
  };
}
