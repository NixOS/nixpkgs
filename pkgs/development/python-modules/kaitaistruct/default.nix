{ stdenv, kaitaistruct, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "kaitaistruct";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19j3snmr0qbd48f7yd3cc21ffv13dahf8ys591dnalbhvnkar71i";
  };

  meta = with stdenv.lib; {
    description = "Kaitai Struct: runtime library for Python";
    homepage = "https://github.com/kaitai-io/kaitai_struct_python_runtime";
    license = licenses.mit;
  };
}
