{ lib, buildPythonPackage, fetchPypi, setuptools_scm
, inflect, more-itertools, six, pytest
}:

buildPythonPackage rec {
  pname = "jaraco.itertools";
  version = "4.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zxx8ffk5ycapy2d41dfgzskl5jfwjc10hsd91jsrax5alkhrh7x";
  };

  patches = [ ./0001-Don-t-run-flake8-checks-during-the-build.patch ];

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ inflect more-itertools six ];
  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Tools for working with iterables";
    homepage = https://github.com/jaraco/jaraco.itertools;
    license = licenses.mit;
  };
}
