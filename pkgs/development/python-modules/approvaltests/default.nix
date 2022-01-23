{ lib, buildPythonPackage, fetchFromGitHub, pyperclip }:

buildPythonPackage rec {
  version = "3.3.2";
  pname = "approvaltests";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = version;
    sha256 = "15blwjzd6nwh0kzxa9xxscxdn0vqwb1bax8d46wk01dcywdyd6ni";
  };

  propagatedBuildInputs = [ pyperclip ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyperclip==1.5.27" "pyperclip>=1.5.27"
  '';

  meta = with lib; {
    description = "Assertion/verification library to aid testing";
    homepage = "https://github.com/approvals/ApprovalTests.Python";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
