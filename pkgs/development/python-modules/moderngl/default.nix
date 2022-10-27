{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, libGL
, libX11
, glcontext
}:

buildPythonPackage rec {
  pname = "moderngl";
  version = "5.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NDTZ4comjJY/dEvrTdxHR88fQ1lZU2zSWZ43f7YqvT8=";
  };

  disabled = !isPy3k;

  buildInputs = [ libGL libX11 ];
  propagatedBuildInputs = [ glcontext ];

  # Tests need a display to run.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/moderngl/moderngl";
    description = "High performance rendering for Python 3";
    license = licenses.mit;
    platforms = platforms.linux; # should be mesaPlatforms, darwin build breaks.
    maintainers = with maintainers; [ c0deaddict ];
  };
}
