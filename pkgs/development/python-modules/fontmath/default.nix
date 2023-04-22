{ lib, buildPythonPackage, fetchPypi, isPy27
, fonttools, setuptools-scm
, pytest, pytest-runner
}:

buildPythonPackage rec {
  pname = "fontMath";
  version = "0.9.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-alOHy3/rEFlY2y9c7tyHhRPMNb83FeJiCQ8FV74MGxw=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ fonttools ];
  nativeCheckInputs = [ pytest pytest-runner ];

  meta = with lib; {
    description = "A collection of objects that implement fast font, glyph, etc. math";
    homepage = "https://github.com/robotools/fontMath/";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
