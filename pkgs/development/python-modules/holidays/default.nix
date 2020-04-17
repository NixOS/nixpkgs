{ stdenv, buildPythonPackage, fetchPypi, six, dateutil, convertdate }:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dx39krafb6cdnd7h5vgwmw4y075s6k3d31a6vhwvqhmdig3294h";
  };

  propagatedBuildInputs = [ six dateutil convertdate ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/dr-prodigy/python-holidays";
    description = "Generate and work with holidays in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
