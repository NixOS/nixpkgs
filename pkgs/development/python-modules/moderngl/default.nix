{ lib
, buildPythonPackage
, fetchPypi
, libGL
, libX11
, glcontext
, pythonOlder
}:

buildPythonPackage rec {
  pname = "moderngl";
  version = "5.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sfmCY5Yny1HgZfEN10AE1Ev1EVQ6JE51646DXjoQxyA=";
  };

  buildInputs = [
    libGL
    libX11
  ];

  propagatedBuildInputs = [
    glcontext
  ];

  # Tests need a display to run.
  doCheck = false;

  pythonImportsCheck = [
    "moderngl"
  ];

  meta = with lib; {
    description = "High performance rendering for Python";
    homepage = "https://github.com/moderngl/moderngl";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
    # should be mesaPlatforms, darwin build breaks.
    platforms = platforms.linux;
  };
}
