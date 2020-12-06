{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "kaitaistruct";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d5845817ec8a4d5504379cc11bd570b038850ee49c4580bc0998c8fb1d327ad";
  };

  meta = with stdenv.lib; {
    description = "Kaitai Struct: runtime library for Python";
    homepage = "https://github.com/kaitai-io/kaitai_struct_python_runtime";
    license = licenses.mit;
  };
}
