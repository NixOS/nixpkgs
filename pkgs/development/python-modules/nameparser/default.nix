{ stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "nameparser";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kc2phcz22r7vim3hmq0vrp2zqxl6v49hq40jmp4p81pdvgh5c6b";
  };

  LC_ALL="en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    description = "A simple Python module for parsing human names into their individual components";
    homepage = https://github.com/derek73/python-nameparser;
    license = licenses.lgpl21Plus;
  };

}
