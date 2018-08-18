{ stdenv, buildPythonPackage, fetchPypi, pytest, isPy3k }:
buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.8.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f32804bb58a66e13a3eda11f8942a71b1b6a30466b0d2ffe9214787aab0e172e";
  };

  buildInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "library for testing asyncio code with pytest";
    license = licenses.asl20;
    homepage = https://github.com/pytest-dev/pytest-asyncio;
  };
}
