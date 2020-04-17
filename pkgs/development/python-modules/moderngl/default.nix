{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, libGL
, libX11
}:

buildPythonPackage rec {
  pname = "moderngl";
  version = "5.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08badabb6a1bbc9aa9e65fae8ecd3275d8342cb45d9c457b19e32b3312a8b663";
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
