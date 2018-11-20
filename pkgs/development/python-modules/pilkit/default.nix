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
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e00585f5466654ea2cdbf7decef9862cb00e16fd363017fa7ef6623a16b0d2c7";
  };

  preConfigure = ''
    substituteInPlace setup.py --replace 'nose==1.2.1' 'nose'
  '';

  # tests fail, see https://github.com/matthewwithanm/pilkit/issues/9
  doCheck = false;

  buildInputs = [ pillow nose_progressive nose mock blessings ];

  meta = with stdenv.lib; {
    homepage = http://github.com/matthewwithanm/pilkit/;
    description = "A collection of utilities and processors for the Python Imaging Libary";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}
