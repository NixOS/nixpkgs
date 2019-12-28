{ stdenv
, buildPythonPackage
, fetchPypi

# Python Dependencies
, six
}:

buildPythonPackage rec {
  pname = "mixpanel";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p446i5y70mm23qlqjnhayksxpwymji334brcv3vw3rrr6xmwfdb";
  };

  propagatedBuildInputs = [ six ];
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/mixpanel/mixpanel-python;
    description = ''This is the official Mixpanel Python library'';
    license = licenses.asl20;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };

}
