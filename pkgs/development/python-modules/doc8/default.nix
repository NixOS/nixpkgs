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
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d1df12598807cf08ffa9a1d5ef42d229ee0de42519da01b768ff27211082c12";
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
