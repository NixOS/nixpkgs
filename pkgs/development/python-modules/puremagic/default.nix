{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook }:

buildPythonPackage rec {
  pname = "puremagic";
  version = "1.10";

  # test/resources are not included in pypi distribution
  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = pname;
    rev = version;
    sha256 = "0wn2apglgyll1znf3whyfahprw8znnk29x2l0z62lqf0y6hjdrvl";
  };

  # Argparse is part of the standard library of modern python versions.
  postPatch = ''
    substituteInPlace setup.py --replace "argparse" ""
  '';

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/cdgriffith/puremagic";
    description = "Pure python implementation of magic file detection";
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
  };
}
