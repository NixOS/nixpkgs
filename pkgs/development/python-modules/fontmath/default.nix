{ lib, buildPythonPackage, fetchPypi, isPy27
, fonttools, setuptools-scm
, pytest, pytest-runner
}:

buildPythonPackage rec {
  pname = "fontMath";
  version = "0.8.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m2z2wwbxwljfcrg8hx4xq538adzcjpc352yqbfw0czbgs5ixmrr";
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
