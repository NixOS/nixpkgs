{ stdenv, buildPythonPackage, fetchFromGitHub, isPy37, pyperclip }:

buildPythonPackage rec {
  version = "0.2.4";
  pname = "approvaltests";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = version;
    sha256 = "05lj5i13zpkgw1wdc1v81wj4zqj8bpzqiwycdnwlg08azcy7k7j1";
  };

  propagatedBuildInputs = [ pyperclip ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyperclip==1.5.27" "pyperclip>=1.5.27"
  '';

  # Tests fail on Python 3.7
  # https://github.com/approvals/ApprovalTests.Python/issues/36
  doCheck = !isPy37;

  # Disable Linux failing test, because tries to use darwin/windows specific reporters
  preCheck = stdenv.lib.optionalString stdenv.isLinux ''
    substituteInPlace tests/test_genericdiffreporter.py \
      --replace "test_find_working_reporter" "_find_working_reporter"
  '';

  meta = with stdenv.lib; {
    description = "Assertion/verification library to aid testing";
    homepage = https://github.com/approvals/ApprovalTests.Python;
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
