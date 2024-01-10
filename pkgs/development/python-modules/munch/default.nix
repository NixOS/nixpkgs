{ lib
, buildPythonPackage
, fetchPypi
, six
, pbr
}:

buildPythonPackage rec {
  pname = "munch";
  version = "4.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VCyxUUYSYyFqTjfD/Zr8Ql/urziqowJc0qmB+ttCIjU=";
  };

  propagatedBuildInputs = [ six pbr ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A dot-accessible dictionary (a la JavaScript objects)";
    license = licenses.mit;
    homepage = "https://github.com/Infinidat/munch";
  };

}
