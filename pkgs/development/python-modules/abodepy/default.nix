{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, colorlog, lomond
, requests, isPy3k, requests-mock }:

buildPythonPackage rec {
  pname = "abodepy";
  version = "1.2.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "MisterWil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m2cm90yy7fq7yrjyd999m48gqri65ifi7f6hc0s3pv2hfj89yj0";
  };

  propagatedBuildInputs = [ colorlog lomond requests ];
  checkInputs = [ pytestCheckHook requests-mock ];

  meta = with lib; {
    homepage = "https://github.com/MisterWil/abodepy";
    description = "An Abode alarm Python library running on Python 3";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
