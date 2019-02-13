{ lib
, buildPythonPackage
, fetchPypi
, re2
, pytest
}:

buildPythonPackage rec {
  pname = "fb-re2";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wd97qdcafcca90s6692g2dmzl5n6cdvm20vn7pmag3l9gvx395c";
  };

  buildInputs = [ re2 ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Python wrapper for Google's RE2";
    homepage = https://github.com/facebook/pyre2;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
