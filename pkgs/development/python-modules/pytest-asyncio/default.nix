{ lib, buildPythonPackage, fetchPypi, pytest, isPy3k, isPy35, async_generator }:
buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.16.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7496c5977ce88c34379df64a66459fe395cd05543f0a2f837016e7144391fcfb";
  };

  buildInputs = [ pytest ]
    ++ lib.optionals isPy35 [ async_generator ];

  # No tests in archive
  doCheck = false;

  # LICENSE file is not distributed. https://github.com/pytest-dev/pytest-asyncio/issues/92
  postPatch = ''
    substituteInPlace setup.cfg --replace "license_file = LICENSE" ""
  '';

  meta = with lib; {
    description = "library for testing asyncio code with pytest";
    license = licenses.asl20;
    homepage = "https://github.com/pytest-dev/pytest-asyncio";
  };
}
