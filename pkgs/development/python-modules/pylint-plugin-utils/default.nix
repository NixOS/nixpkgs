{ stdenv, buildPythonPackage, fetchPypi, pylint }:

buildPythonPackage rec {
  pname = "pylint-plugin-utils";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x0bpbvfjhqixz15nz7469m8jdaj9as3dwghw41h0ywbxbak37ld";
  };

  propagatedBuildInputs = [ pylint ];

  meta = with stdenv.lib; {
    description = "Utilities and helpers for writing Pylint plugins";
    homepage = https://github.com/PyCQA/pylint-plugin-utils;
    license = licenses.gpl2;
    maintainers = with maintainers; [ gerschtli ];
  };
}
