{ lib, buildPythonPackage, fetchFromGitHub, pep8, nose }:

buildPythonPackage rec {
  version = "0.8";
  format = "setuptools";
  pname = "cgroup-utils";

  buildInputs = [ pep8 nose ];
  # Pep8 tests fail...
  doCheck = false;

  postPatch = ''
    sed -i -e "/argparse/d" setup.py
  '';

  src = fetchFromGitHub {
    owner = "peo3";
    repo = "cgroup-utils";
    rev = "v${version}";
    sha256 = "0qnbn8cnq8m14s8s1hcv25xjd55dyb6yy54l5vc7sby5xzzp11fq";
  };

  meta = with lib; {
    description = "Utility tools for control groups of Linux";
    maintainers = with maintainers; [ layus ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
