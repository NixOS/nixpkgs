{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytestrunner
, pytest
}:

buildPythonPackage rec {
  pname = "multiset";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4801569c08bfcecfe7b0927b17f079c90f8607aca8fecaf42ded92b737162bc7";
  };

  buildInputs = [ setuptools_scm pytestrunner ];
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "An implementation of a multiset";
    homepage = https://github.com/wheerd/multiset;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
