{ lib, buildPythonPackage, fetchurl, cffi }:

buildPythonPackage rec {
  pname = "milksnake";
  version = "0.1.1";

  src = fetchurl {
    url = "https://pypi.python.org/packages/04/12/358c2c7a27f06a71d69e44a4b7f62411524c25e6c7284b5a0f757a9ba068/milksnake-0.1.1.zip";
    sha256 = "12bdyc2kjqpiq8wrbsk7ymcq2xdakri3bsvaqgsyzj33wyzbcwzy";
  };

  propagatedBuildInputs = [
   cffi
  ];

  meta = with lib; {
    description = "A python library that extends setuptools for binary extensions.";
    homepage = https://pypi.python.org/pypi/milksnake/;
    license = licenses.apl;
  };
}
