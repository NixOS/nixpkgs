{ lib
, buildPythonPackage
, fetchFromGitHub
, nmigen
, setuptools
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "nmigen-soc";
  version = "unstable-2021-02-09";
  # python setup.py --version
  realVersion = "0.1.dev43+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "nmigen";
    repo = "nmigen-soc";
    rev = "ecfad4d9abacf903a525f0a252c38844eda0d2dd";
    sha256 = "0afmnfs1ms7p1r4c1nc0sfvlcq36zjwaim7775v5i2vajcn3020c";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ setuptools nmigen ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "System on Chip toolkit for nMigen";
    homepage = "https://github.com/nmigen/nmigen-soc";
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily ];
  };
}
