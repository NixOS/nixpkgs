{ lib, stdenv, buildPythonPackage, fetchPypi, numpy, pyserial, scipy }:

buildPythonPackage rec {
  pname = "pslab";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0iifjz7j6g982sc1id91d2krrv6zr42v2fzln9kw7nwjzg1j2j3a";
  };

  # Testing requires Pil, some patches...
  doCheck = false;

  propagatedBuildInputs = [ numpy pyserial scipy ];

  pythonImportsCheck = [ "pslab" ];

  meta = with lib; {
    description = "The Python library for the Pocket Science Lab from FOSSASIA";
    homepage = "https://github.com/fossasia/pslab-python";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.viric ];
  };
}
