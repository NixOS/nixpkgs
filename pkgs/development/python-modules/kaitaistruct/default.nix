{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "kaitaistruct";
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1d17c7f6839b3d28fc22b21295f787974786c2201e8788975e72e2a1d109ff5";
  };

  meta = with stdenv.lib; {
    description = "Kaitai Struct: runtime library for Python";
    homepage = https://github.com/kaitai-io/kaitai_struct_python_runtime;
    license = licenses.mit;
  };
}
