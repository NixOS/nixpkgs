{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "EasyProcess";
  version = "0.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da7f67a006e2eb63d86a8f3f4baa9d6752dab9676009a67193a4e433f2f41c2a";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Easy to use python subprocess interface";
    homepage = https://github.com/ponty/EasyProcess;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}
