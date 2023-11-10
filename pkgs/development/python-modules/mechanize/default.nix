{ lib
, buildPythonPackage
, fetchPypi
, html5lib
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aaXtsJYvkh6LEINzaMIkLYrQSfC5H/aZzn9gG/xDFSE=";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = "https://github.com/python-mechanize/mechanize";
    license = "BSD-style";
  };

}
