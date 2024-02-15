{ buildPythonPackage, lib, lxml, click, fetchFromGitHub, pytestCheckHook, asn1crypto }:

buildPythonPackage rec {
  version = "0.3.27";
  format = "setuptools";
  pname = "pyaxmlparser";

  src = fetchFromGitHub {
    owner = "appknox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NtAsO/I1jDEv676yhAgLguQnB/kHdAqPoLt2QFWbvmw=";
  };

  propagatedBuildInputs = [ asn1crypto click lxml ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python3 Parser for Android XML file and get Application Name without using Androguard";
    homepage = "https://github.com/appknox/pyaxmlparser";
    # Files from Androguard are licensed ASL 2.0
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ];
  };
}
