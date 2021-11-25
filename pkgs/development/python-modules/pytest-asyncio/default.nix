{ lib, buildPythonPackage, fetchPypi, pytest, isPy3k, isPy35, async_generator }:
buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.15.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2564ceb9612bbd560d19ca4b41347b54e7835c2f792c504f698e05395ed63f6f";
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
