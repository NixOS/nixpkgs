{ stdenv
, buildPythonPackage
, fetchPypi
, pillow
, nose_progressive
, nose
, mock
, blessings
}:

buildPythonPackage rec {
  pname = "pilkit";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ddb30c2f0198a147e56b151476c3bb9fe045fbfd5b0a0fa2a3148dba62d1559f";
  };

  preConfigure = ''
    substituteInPlace setup.py --replace 'nose==1.2.1' 'nose'
  '';

  # tests fail, see https://github.com/matthewwithanm/pilkit/issues/9
  doCheck = false;

  buildInputs = [ pillow nose_progressive nose mock blessings ];

  meta = with stdenv.lib; {
    homepage = https://github.com/matthewwithanm/pilkit/;
    description = "A collection of utilities and processors for the Python Imaging Libary";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}
