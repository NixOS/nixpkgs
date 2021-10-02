{ lib, buildPythonPackage, fetchPypi, isPy3k
, pyserial }:

buildPythonPackage rec {
  pname = "pyserial-asyncio";
  version = "0.6";

  disabled = !isPy3k; # Doesn't support python older than 3.4

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tgMpI+BenXXsF6WvmphCnEbSg5rfr4BgTVLg+qzXoy8=";
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
