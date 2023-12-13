{ lib
, buildPythonPackage
, fetchFromGitHub
, amaranth
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "amaranth-soc";
  version = "unstable-2023-09-15";
  format = "setuptools";
  # python setup.py --version
  realVersion = "0.1.dev70+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth-soc";
    rev = "cce8a79a37498f4d5900be21a295ba77e51e6c9d";
    sha256 = "sha256-hfkJaqICuy3iSTwLM9lbUPvSMDBLW8GdxqswyAOsowo=";
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
