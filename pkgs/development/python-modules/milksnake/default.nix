{ lib, buildPythonPackage, fetchPypi, cffi }:

buildPythonPackage rec {
  pname = "milksnake";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "120nprd8lqis7x7zy72536gk2j68f7gxm8gffmx8k4ygifvl7kfz";
  };

  propagatedBuildInputs = [
   cffi
  ];

  # tests rely on pip/venv
  doCheck = false;

  meta = with lib; {
    description = "A python library that extends setuptools for binary extensions";
    homepage = "https://github.com/getsentry/milksnake";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
