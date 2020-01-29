{ buildPythonPackage
, future
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "pefile";
  version = "2019.4.18";

  propagatedBuildInputs = [ future ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5d6e8305c6b210849b47a6174ddf9c452b2888340b8177874b862ba6c207645";
  };

  # Test data encrypted.
  doCheck = false;

  # Verify import still works.
  pythonImportsCheck = [ "pefile" ];

  meta = with lib; {
    description = "Multi-platform Python module to parse and work with Portable Executable (aka PE) files";
    homepage = "https://github.com/erocarrera/pefile";
    license = licenses.mit;
    maintainers = [ maintainers.pamplemousse ];
  };
}
