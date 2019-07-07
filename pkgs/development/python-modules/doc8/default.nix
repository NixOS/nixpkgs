{ lib
, buildPythonPackage
, fetchPypi
, pbr
, docutils
, six
, chardet
, stevedore
, restructuredtext_lint
}:

buildPythonPackage rec {
  pname = "doc8";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2df89f9c1a5abfb98ab55d0175fed633cae0cf45025b8b1e0ee5ea772be28543";
  };

  buildInputs = [ pbr ];
  propagatedBuildInputs = [ docutils six chardet stevedore restructuredtext_lint ];

  doCheck = false;

  meta = {
    description = "Style checker for Sphinx (or other) RST documentation";
    homepage = "https://launchpad.net/doc8";
    license = lib.licenses.asl20;
  };
}
