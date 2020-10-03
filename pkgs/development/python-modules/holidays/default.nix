{ stdenv
, buildPythonPackage
, fetchPypi
, convertdate
, dateutil
, korean-lunar-calendar
, six
}:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "839281f2b1ae7ac576da7951472482f6e714818296853107ea861fa60f5013cc";
  };

  propagatedBuildInputs = [
    convertdate
    dateutil
    korean-lunar-calendar
    six
  ];
  pythonImportsCheck = [ "holidays" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/dr-prodigy/python-holidays";
    description = "Generate and work with holidays in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
