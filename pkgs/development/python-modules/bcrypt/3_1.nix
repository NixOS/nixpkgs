{ lib, buildPythonPackage, fetchPypi
, isPyPy, cffi, pytest, six }:

buildPythonPackage rec {
  version = "3.1.7";
  pname = "bcrypt";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b0069c752ec14172c5f78208f1863d7ad6755a6fae6fe76ec2c80d13be41e42";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ six ] ++ lib.optional (!isPyPy) cffi;

  meta = with lib; {
    description = "Modern password hashing for your software and your servers";
    homepage = "https://github.com/pyca/bcrypt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ domenkozar ];
  };
}
