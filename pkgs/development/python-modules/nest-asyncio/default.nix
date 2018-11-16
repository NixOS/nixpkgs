{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  version = "0.9.1";
  pname = "nest_asyncio";
  disabled = !(pythonAtLeast "3.5");

  src = fetchPypi {
    inherit pname version;
    sha256 = "0844af67deda3243389d47cd8754b6775c5c828345e0277beca7bd008d273392";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/erdewit/nest_asyncio;
    description = "Patch asyncio to allow nested event loops";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
