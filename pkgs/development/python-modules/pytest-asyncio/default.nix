{ lib, stdenv, buildPythonPackage, fetchPypi, pytest, isPy3k, isPy35, async_generator }:
buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.14.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9882c0c6b24429449f5f969a5158b528f39bde47dc32e85b9f0403965017e700";
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
