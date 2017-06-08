{ lib
, fetchurl
, stdenv 
, python3Packages
, buildPythonPackage }:

buildPythonPackage rec {
    name = "astropy";
    version = "1.3.3";
    src = fetchurl {
      url = "https://pypi.python.org/packages/f2/ad/110f13061ca68f3397216c2716b6687efab4d85e59366d94414c92274554/astropy-1.3.3.tar.gz";
      sha256 = "ed093e033fcbee5a3ec122420c3376f8a80f74663214560727d3defe82170a99";      
  };
  doCheck = false;
  buildInputs = with python3Packages; [ numpy ];


  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = "http://www.astropy.org";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ KentJames ];
  };
  }


