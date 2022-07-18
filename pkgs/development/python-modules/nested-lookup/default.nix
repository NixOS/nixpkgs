{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "nested-lookup";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "russellballestrini";
    repo = "nested-lookup";
    # https://github.com/russellballestrini/nested-lookup/issues/47
    rev = "c1b0421479efa378545bc71efa3b72882e8fec17";
    sha256 = "sha256-jgfYLSsFLQSsOH4NzbDPKFIG+tWWZ1zTWcZEaX2lthg=";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nested_lookup" ];

  meta = with lib; {
    description = "Python functions for working with deeply nested documents (lists and dicts)";
    homepage = "https://github.com/russellballestrini/nested-lookup";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ tboerger ];
  };
}
