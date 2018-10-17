{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "nose2";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0595rh6b6dncbj0jigsyrgrh6h8fsl6w1fr69h76mxv9nllv0rlr";
  };

  propagatedBuildInputs = [ six ];
  # AttributeError: 'module' object has no attribute 'collector'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "nose2 is the next generation of nicer testing for Python";
    homepage = https://github.com/nose-devs/nose2;
    license = licenses.bsd0;
  };

}
