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
  version = "5.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tmwY1/SrepS+P5655MpoNurR2lAtYugbf3pIFQ4u05E=";
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
    changelog = "https://github.com/moderngl/moderngl/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
    # should be mesaPlatforms, darwin build breaks.
    platforms = platforms.linux;
  };
}
