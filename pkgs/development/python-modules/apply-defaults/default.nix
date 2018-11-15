{ stdenv, buildPythonPackage, fetchPypi, pytest
}:

buildPythonPackage rec {
  pname = "apply_defaults";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8c1bc511a0368dabe1af4d80b97186296e25182d7e371d920a9633cf6a2a385";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/bcb/apply_defaults;
    description = "Apply default values to functions";
    license = licenses.free;
    maintainers = with maintainers; [ jb55 ];
  };
}
