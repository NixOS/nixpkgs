{ lib
, buildPythonPackage
, fetchFromGitHub
, nmigen
, setuptools
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "nmigen-soc";
  version = "unstable-2020-02-08";
  # python setup.py --version
  realVersion = "0.1.dev24+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "nmigen";
    repo = "nmigen-soc";
    rev = "f1b009c7e075bca461d10ec963a7eaa3bf4dfc14";
    sha256 = "04kjaq9qp6ac3h0r1wlb4jyz56bb52l1rikmz1x7azvnr10xhrad";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ setuptools nmigen ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "System on Chip toolkit for nMigen";
    homepage = https://github.com/nmigen/nmigen-soc;
    license = licenses.bsd2;
    maintainers = with maintainers; [ emily ];
  };
}
