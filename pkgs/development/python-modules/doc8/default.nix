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
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "376e50f4e70a1ae935416ddfcf93db35dd5d4cc0e557f2ec72f0667d0ace4548";
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
