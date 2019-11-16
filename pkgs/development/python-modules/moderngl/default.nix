{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, libGL
, libX11
}:

buildPythonPackage rec {
  pname = "moderngl";
  version = "5.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k2yf2yglzx65gcv2bqql6w6lmgyp3f1jz4ddq9vylf09a8j7fga";
  };

  disabled = !isPy3k;

  buildInputs = [ libGL libX11 ];

  # Tests need a display to run.
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/moderngl/moderngl;
    description = "High performance rendering for Python 3";
    license = licenses.mit;
    platforms = platforms.linux; # should be mesaPlatforms, darwin build breaks.
    maintainers = with maintainers; [ c0deaddict ];
  };
}
