{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.50";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c67365b26060452631c0083a0f5d50af3cba9287b84b2c157404c959cb4bb74d";
  };

  nativeBuildInputs = [ setuptools ];

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  meta = with lib; {
    description = "A library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
