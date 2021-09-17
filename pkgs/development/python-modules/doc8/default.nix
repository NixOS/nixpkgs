{ lib
, buildPythonPackage
, fetchPypi
, pbr
, docutils
, six
, chardet
, stevedore
, restructuredtext_lint
, pygments
}:

buildPythonPackage rec {
  pname = "doc8";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "380b660474be40ce88b5f04fa93470449124dbc850a0318f2ef186162bc1360b";
  };

  buildInputs = [ pbr ];
  propagatedBuildInputs = [
    docutils
    six
    chardet
    stevedore
    restructuredtext_lint
    pygments
  ];

  doCheck = false;

  meta = {
    description = "Style checker for Sphinx (or other) RST documentation";
    homepage = "https://launchpad.net/doc8";
    license = lib.licenses.asl20;
  };
}
