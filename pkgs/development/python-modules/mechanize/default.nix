{ lib
, buildPythonPackage
, fetchPypi
, html5lib
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d16cea241253b5eb6380bf8a46627cad91d1f2c3f93a33279a31ce276d6c5d44";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = "https://github.com/python-mechanize/mechanize";
    license = "BSD-style";
  };

}
