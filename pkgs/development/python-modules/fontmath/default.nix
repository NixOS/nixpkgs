{ lib, buildPythonPackage, fetchPypi, isPy27
, fonttools, setuptools-scm
, pytest, pytest-runner
}:

buildPythonPackage rec {
  pname = "fontMath";
  version = "0.9.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c5e76e135409f49b15809d0ce94dfd00850f893f86d4d6a336808dbbf292700";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ fonttools ];
  checkInputs = [ pytest pytest-runner ];

  meta = with lib; {
    description = "A collection of objects that implement fast font, glyph, etc. math";
    homepage = "https://github.com/robotools/fontMath/";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
