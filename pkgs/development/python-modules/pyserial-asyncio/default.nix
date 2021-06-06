{ lib, buildPythonPackage, fetchPypi, isPy3k
, pyserial }:

buildPythonPackage rec {
  pname = "pyserial-asyncio";
  version = "0.5";

  disabled = !isPy3k; # Doesn't support python older than 3.4

  src = fetchPypi {
    inherit pname version;
    sha256 = "1641e5433a866eeaf6464b3ab88b741e7a89dd8cd0f851b3343b15f425138d33";
  };

  propagatedBuildInputs = [ pyserial ];

  meta = with lib; {
    description = "asyncio extension package for pyserial";
    homepage = "https://github.com/pyserial/pyserial-asyncio";
    license = licenses.bsd3;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
