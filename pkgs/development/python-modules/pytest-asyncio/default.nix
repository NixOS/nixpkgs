{ stdenv, buildPythonPackage, fetchPypi, pytest, isPy3k }:
buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.9.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbd92c067c16111174a1286bfb253660f1e564e5146b39eeed1133315cf2c2cf";
  };

  buildInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  # LICENSE file is not distributed. https://github.com/pytest-dev/pytest-asyncio/issues/92
  postPatch = ''
    substituteInPlace setup.cfg --replace "license_file = LICENSE" ""
  '';

  meta = with stdenv.lib; {
    description = "library for testing asyncio code with pytest";
    license = licenses.asl20;
    homepage = https://github.com/pytest-dev/pytest-asyncio;
  };
}
