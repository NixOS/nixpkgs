{ stdenv, buildPythonPackage, fetchPypi, pytest, isPy3k, isPy35, async_generator }:
buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.12.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lpb1q297rly685yl23mni3mmv6vmyx3qsv5ccj1vh8bvkrx4ns7";
  };

  buildInputs = [ pytest ]
    ++ stdenv.lib.optionals isPy35 [ async_generator ];

  # No tests in archive
  doCheck = false;

  # LICENSE file is not distributed. https://github.com/pytest-dev/pytest-asyncio/issues/92
  postPatch = ''
    substituteInPlace setup.cfg --replace "license_file = LICENSE" ""
  '';

  meta = with stdenv.lib; {
    description = "library for testing asyncio code with pytest";
    license = licenses.asl20;
    homepage = "https://github.com/pytest-dev/pytest-asyncio";
  };
}
