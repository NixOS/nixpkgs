{ lib, buildPythonPackage, fetchPypi, aiohttp, future-fstrings, pythonOlder }:

buildPythonPackage rec {
  pname = "mautrix-appservice";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "60192920cff75afdd096eea3a43276e33ec15f4f00bd04d2d1dda616c84f22a5";
  };

  patches = lib.optional (!(pythonOlder "3.6")) [
    ./0001-Remove-coding-annotations.patch
  ];

  propagatedBuildInputs = [
    aiohttp
    future-fstrings
  ];

  # No tests available
  doCheck = false;

  disabled = pythonOlder "3.5";

  meta = with lib; {
    homepage = https://github.com/tulir/mautrix-appservice-python;
    description = "A Python 3 asyncio-based Matrix application service framework";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
