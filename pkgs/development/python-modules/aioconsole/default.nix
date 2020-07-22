{ lib, buildPythonPackage, fetchPypi }:

# This package provides a binary "apython" which sometimes invokes
# [sys.executable, '-m', 'aioconsole'] as a subprocess. If apython is
# run directly out of this derivation, it won't work, because
# sys.executable will point to a Python binary that is not wrapped to
# be able to find aioconsole.
# However, apython will work fine when using python##.withPackages,
# because with python##.withPackages the sys.executable is already
# wrapped to be able to find aioconsole and any other packages.
buildPythonPackage rec {
  pname = "aioconsole";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l61zv6qq94ybqz7s8ag3h08dsh7jds6n2mgd43s7m8gbiy00ggn";
  };

  # hardcodes a test dependency on an old version of pytest-asyncio
  doCheck = false;

  meta = {
    description = "Asynchronous console and interfaces for asyncio";
    homepage = "https://github.com/vxgmichel/aioconsole";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.catern ];
  };
}
