{ stdenv, buildPythonPackage, fetchFromGitHub, isPy37, pyperclip }:

buildPythonPackage rec {
  version = "0.2.6";
  pname = "approvaltests";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = version;
    sha256 = "1k1bj8q1qm89a8xm4az6qk4qswwmgxw5jpdjcxmf93zh5hrcy9h9";
  };

  propagatedBuildInputs = [ pyperclip ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyperclip==1.5.27" "pyperclip>=1.5.27"
  '';

  meta = with stdenv.lib; {
    description = "Assertion/verification library to aid testing";
    homepage = "https://github.com/approvals/ApprovalTests.Python";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
