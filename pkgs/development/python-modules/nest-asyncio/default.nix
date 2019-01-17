{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  version = "0.9.10";
  pname = "nest_asyncio";
  disabled = !(pythonAtLeast "3.5");

  src = fetchPypi {
    inherit pname version;
    sha256 = "d952e21f4333166d79423db2eda6d772be7b30134381ee055d5177be0db68a57";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/erdewit/nest_asyncio;
    description = "Patch asyncio to allow nested event loops";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
