{ lib, buildPythonPackage, fetchFromGitHub
, beautifulsoup4
, empty-files
, numpy
, pyperclip
, pytest
}:

buildPythonPackage rec {
  version = "3.7.0";
  pname = "approvaltests";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = "v${version}";
    sha256 = "sha256-Oz3pHfLE9zNbOw95yqjb2b8wAhXQwfaI/vlIHAYtvWc=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    empty-files
    numpy
    pyperclip
    pytest
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace bs4 beautifulsoup4 \
      --replace "pyperclip==1.5.27" "pyperclip>=1.5.27"
  '';

  meta = with lib; {
    description = "Assertion/verification library to aid testing";
    homepage = "https://github.com/approvals/ApprovalTests.Python";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
