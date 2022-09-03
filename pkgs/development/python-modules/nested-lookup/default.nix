{ buildPythonPackage
, fetchFromGitLab
, lib
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "nested-lookup";
  version = "0.2.25";

  src = fetchFromGitLab {
    domain = "git.unturf.com";
    owner = "python";
    repo = "nested-lookup";
    # https://github.com/russellballestrini/nested-lookup/issues/47
    rev = "279dcb418923f445b2c8aa0c21ebd4dc2d70dcd8";
    hash = "sha256-4WLqwI5riSWEdaobtEAtnxHWsWTGYFIRhSiFwBpS694=";
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
    homepage = "https://git.unturf.com/python/nested-lookup";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ tboerger ];
  };
}
