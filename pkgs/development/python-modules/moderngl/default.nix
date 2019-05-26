{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, libGL
, libX11
}:

buildPythonPackage rec {
  pname = "moderngl";
  version = "5.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x8xblc3zybp7jw9cscpm4r5pmmilj9l4yi1rkxyf0y80kchlxq4";
  };

  disabled = !isPy3k;

  buildInputs = [ libGL libX11 ];

  # Tests need a display to run.
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/cprogrammer1994/ModernGL;
    description = "High performance rendering for Python 3";
    license = licenses.mit;
    platforms = platforms.linux; # should be mesaPlatforms, darwin build breaks.
    maintainers = with maintainers; [ c0deaddict ];
  };
}
