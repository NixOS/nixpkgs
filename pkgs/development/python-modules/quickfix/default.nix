{ lib, stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "quickfix";
  version = "1.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-41ZK0t0VWJLcdEltb02xeUvY+fdEUMy7RVcf+qKBXaI=";
  };

  meta = with lib; {
    description = "FIX Engine Library";
    homepage = "https://github.com/quickfix/quickfix/";
    license = licenses.free;
    maintainers = with maintainers; [ edjroot ];
    platforms = platforms.linux;
  };
}
