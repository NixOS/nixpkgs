{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec{
  pname = "riprova";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04drdvjjbh370csv2vb5zamg2aanxqkfm6w361qkybnra4g4g0dz";
  };

  propagatedBuildInputs = [ six ];

  # PyPI archive doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "riprova" ];

  meta = with lib; {
    homepage = "https://github.com/h2non/riprova";
    description = "Small and versatile library to retry failed operations using different backoff strategies";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata ];
  };
}
