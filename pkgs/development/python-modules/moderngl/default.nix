{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, libGL
, libX11
}:

buildPythonPackage rec {
  pname = "moderngl";
  version = "5.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c6d04559f5e3bf75a18525cd46d213c0f3a8409363718978e6de691bdb551fb";
  };

  disabled = !isPy3k;

  buildInputs = [ libGL libX11 ];

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
