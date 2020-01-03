{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  version = "1.2.1";
  pname = "nest_asyncio";
  disabled = !(pythonAtLeast "3.5");

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d4d7c1ca2aad0e5c2706d0222c8ff006805abfd05caa97e6127c8811d0f6adc";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/erdewit/nest_asyncio;
    description = "Patch asyncio to allow nested event loops";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
