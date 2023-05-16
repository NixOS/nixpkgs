{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec{
  pname = "riprova";
<<<<<<< HEAD
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FgFySbvBjcZU2bjo40/1O7glc6oFWW05jinEOfMWMVI=";
=======
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04drdvjjbh370csv2vb5zamg2aanxqkfm6w361qkybnra4g4g0dz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
