{ lib
, buildPythonPackage
, fetchFromGitHub
, amaranth
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "amaranth-soc";
  version = "unstable-2021-12-10";
  # python setup.py --version
  realVersion = "0.1.dev49+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth-soc";
    rev = "217d4ea76ad3b3bbf146980d168bc7b3b9d95a18";
    sha256 = "dMip82L7faUn16RDeG3NgMv0nougpwTwDWLX0doD2YA=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ setuptools amaranth ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "System on Chip toolkit for Amaranth HDL";
    homepage = "https://github.com/amaranth-lang/amaranth-soc";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily thoughtpolice ];
  };
}
