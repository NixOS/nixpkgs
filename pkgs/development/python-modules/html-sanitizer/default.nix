{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, beautifulsoup4
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "html-sanitizer";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
    rev = version;
    sha256 = "0nnv34924r0yn01rwlk749j5ijy7yxyj302s1i57yjrkqr3zlvas";
  };

  propagatedBuildInputs = [
    lxml
    beautifulsoup4
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "html_sanitizer/tests.py" ];

  pythonImportsCheck = [ "html_sanitizer" ];

  meta = with lib; {
    description = "Allowlist-based and very opinionated HTML sanitizer";
    homepage = "https://github.com/matthiask/html-sanitizer";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
