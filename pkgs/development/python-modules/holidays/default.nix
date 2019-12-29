{ stdenv, buildPythonPackage, fetchPypi , six, dateutil }:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.9.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3182c4a6fef8d01a829468362ace9c3bba7645873610535fef53454dbb4ea092";
  };

  propagatedBuildInputs = [ six dateutil ];

  meta = with stdenv.lib; {
    homepage = https://github.com/dr-prodigy/python-holidays;
    description = "Generate and work with holidays in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
