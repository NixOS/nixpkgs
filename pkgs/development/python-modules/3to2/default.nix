{ lib
, buildPythonPackage
, fetchurl
, pytest
}:

buildPythonPackage rec {
  pname = "3to2";
  version = "1.1.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/8f/ab/58a363eca982c40e9ee5a7ca439e8ffc5243dde2ae660ba1ffdd4868026b/${pname}-${version}.zip";
    sha256 = "fef50b2b881ef743f269946e1090b77567b71bb9a9ce64b7f8e699b562ff685c";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test lib3to2/tests
  '';

  # Test failing due to upstream issue (https://bitbucket.org/amentajo/lib3to2/issues/50/testsuite-fails-with-new-python-35)
  doCheck = false;

  meta = {
    homepage = https://bitbucket.org/amentajo/lib3to2;
    description = "Refactors valid 3.x syntax into valid 2.x syntax, if a syntactical conversion is possible";
    license = lib.licenses.asl20;
  };
}
