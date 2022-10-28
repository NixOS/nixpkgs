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
  version = "5.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NDTZ4comjJY/dEvrTdxHR88fQ1lZU2zSWZ43f7YqvT8=";
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
