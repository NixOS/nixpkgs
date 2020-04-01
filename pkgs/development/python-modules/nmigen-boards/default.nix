{ lib
, buildPythonPackage
, fetchFromGitHub
, nmigen
, setuptools
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "nmigen-boards";
  version = "unstable-2020-02-06";
  # python setup.py --version
  realVersion = "0.1.dev92+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "nmigen";
    repo = "nmigen-boards";
    rev = "f37fe0295035db5f1bf82ed086b2eb349ab3a530";
    sha256 = "16112ahil100anfwggj64nyrj3pf7mngwrjyqyhf2ggxx9ir24cc";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ setuptools nmigen ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "Board and connector definitions for nMigen";
    homepage = https://github.com/nmigen/nmigen-boards;
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily ];
  };
}
