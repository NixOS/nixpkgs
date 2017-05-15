{ stdenv
, buildPythonPackage
, fetchPypi
, python
, numpy
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pyemd";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1as95f9ppwrxj4hs8980b89vyjza3d8cxf0gf0x75n2gxlymgss8";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';
  
  meta = with stdenv.lib; {
    description = "Fast EMD for Python";
    homepage = https://github.com/wmayner/pyemd;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
