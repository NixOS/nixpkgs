{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "XStatic-asciinema-player";
  version = "1.0.0";


  src = fetchPypi {
    inherit pname version;
    sha256 = "cb11ad0d43deff3a1c3690c74f0c731cff5b862c73339df2edd91133e1496fbc";
  };

  doCheck = false; # pypi version doesn't include tests

  meta = {
    description = "asciinema-player packaged for setuptools";
    longDescription = ''
      Web player for terminal session recordings (as produced by asciinema recorder)
      that you can use on your website by simply adding <asciinema-player> tag
    '';
    homepage = "https://github.com/asciinema/asciinema-player";
    license = lib.licenses.apache;
  };
}
