{ lib, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  pname = "pytzdata";
  version = "2019.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "029ss9ympv6xyixa9x2zhl356np1qfm3qwgh94m68lyqmx91kag8";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Timezone database for Python";
    homepage = "https://github.com/sdispater/pytzdata";
    license = licenses.mit;
  };
}
