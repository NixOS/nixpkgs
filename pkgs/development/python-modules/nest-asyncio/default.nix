{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  version = "0.9.7";
  pname = "nest_asyncio";
  disabled = !(pythonAtLeast "3.5");

  src = fetchPypi {
    inherit pname version;
    sha256 = "309160419228c0291268164e33be2d15514c9364b95fac3c04e14fad2a1c008b";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/erdewit/nest_asyncio;
    description = "Patch asyncio to allow nested event loops";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
