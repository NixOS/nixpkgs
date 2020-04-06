{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, pytest, isPy3k, isPy35, async_generator }:
buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.10.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fac5100fd716cbecf6ef89233e8590a4ad61d729d1732e0a96b84182df1daaf";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pytest-dev/pytest-asyncio/commit/6397a2255e3e9ef858439b164018438a8106f454.patch";
      sha256 = "0dl365idhi2sjd8hbdpr6k0r16vzd942sa5dzl3ykawy80b6rbq8";
      includes = [ "pytest_asyncio/plugin.py" ];
    })
  ];

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
    homepage = https://github.com/pytest-dev/pytest-asyncio;
  };
}
