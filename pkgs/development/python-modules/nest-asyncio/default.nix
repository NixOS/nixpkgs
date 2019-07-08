{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "nest_asyncio";
  disabled = !(pythonAtLeast "3.5");

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd1cb7df2ea979e57d8ad02493ad85f9afbf1fcea3dfe34239da8c0dda98087e";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/erdewit/nest_asyncio;
    description = "Patch asyncio to allow nested event loops";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
