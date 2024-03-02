{ lib
, buildPythonPackage
, fetchFromGitHub
, amaranth
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "amaranth-boards";
  version = "unstable-2021-12-17";
  format = "setuptools";
  # python setup.py --version
  realVersion = "0.1.dev202+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth-boards";
    rev = "8e2615765e255144403431ca95c5cdf6c78eb638";
    sha256 = "3EOG8SO5xBNevshXMRrxKWoJUbeaVi8ckbkmqd6Tw70=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ setuptools amaranth ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Board definitions for Amaranth HDL";
    homepage = "https://github.com/amaranth-lang/amaranth-boards";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily thoughtpolice ];
  };
}
