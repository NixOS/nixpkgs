{ lib, buildPythonPackage, fetchPypi, cffi }:

buildPythonPackage rec {
  pname = "milksnake";
  version = "0.1.1";


  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "12bdyc2kjqpiq8wrbsk7ymcq2xdakri3bsvaqgsyzj33wyzbcwzy";
  };

  propagatedBuildInputs = [
   cffi
  ];

  meta = with lib; {
    description = "A python library that extends setuptools for binary extensions.";
    homepage = https://pypi.python.org/pypi/milksnake/;
    license = licenses.apl;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
