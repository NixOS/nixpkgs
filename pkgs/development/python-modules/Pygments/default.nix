{ lib
, buildPythonPackage
, fetchPypi
, docutils
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f";
  };

  propagatedBuildInputs = [ docutils ];

  # Circular dependency with sphinx
  doCheck = false;
  pythonImportsCheck = [ "pygments" ];

  meta = {
    homepage = "https://pygments.org/";
    description = "A generic syntax highlighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
