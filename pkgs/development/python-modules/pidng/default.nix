{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  numpy,
}:

buildPythonPackage rec {
  pname = "pidng";
  version = "0-unstable-2025-01-21";

  src = fetchFromGitHub {
    owner = "schoolpost";
    repo = "PiDNG";
    rev = "e2f5a8da509c46ea8f85117e2a4ee27ccb60a7ce";
    sha256 = "sha256-+VXC382k5hVEWkSRyiYUbmupZoBCkQmUd8NH3sxXaIo=";
  };

  format = "setuptools";

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "pidng" ];

  meta = with lib; {
    description = "Converts Raspberry Pi raw Bayer data to DNG format";
    homepage = "https://github.com/schoolpost/PiDNG";
    license = licenses.mit;
    maintainers = with maintainers; [ phodina ];
    platforms = platforms.unix;
  };
}
