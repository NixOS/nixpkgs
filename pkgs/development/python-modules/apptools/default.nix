{ stdenv, fetchPypi, buildPythonPackage
, traits, traitsui, configobj
, nose, tables, pandas
}:

buildPythonPackage rec {
  pname = "apptools";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10h52ibhr2aw076pivqxiajr9rpcr1mancg6xlpxzckcm3if02i6";
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
    homepage = "https://github.com/enthought/apptools";
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
