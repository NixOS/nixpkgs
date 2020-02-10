{ lib, buildPythonPackage, fetchPypi, Babel, celery, importlib-metadata, pytz, tornado, mock }:

buildPythonPackage rec {
  pname = "flower";
  version = "0.9.3";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "7f45acb297ab7cf3dd40140816143a2588f6938dbd70b8c46b59c7d8d1e93d55";
  };

  propagatedBuildInputs = [ Babel celery importlib-metadata pytz tornado ];
  
  checkInputs = [ mock ];
  
  meta = with lib; {
    description = "Celery Flower";
    homepage = "https://github.com/mher/flower";
    license = licenses.bsdOriginal;    
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
