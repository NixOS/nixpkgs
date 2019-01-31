{ stdenv, fetchPypi, buildPythonPackage
, traits, traitsui, configobj
, nose, tables, pandas
}:

buildPythonPackage rec {
  pname = "apptools";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dw6vvq7lqkj7mgn3s7r5hs937kl4mj5g7jf2qgvhdld9lsc5xbk";
  };

  propagatedBuildInputs = [ traits traitsui configobj ];

  checkInputs = [
    nose
    tables
    pandas
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Set of packages that Enthought has found useful in creating a number of applications.";
    homepage = https://github.com/enthought/apptools;
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
