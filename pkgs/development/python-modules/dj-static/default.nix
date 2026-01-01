{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  static3,
}:

buildPythonPackage rec {
  pname = "dj-static";
  version = "0.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "heroku-python";
    repo = "dj-static";
    rev = "v${version}";
    hash = "sha256-B6TydlezbDkmfFgJjdFniZIYo/JjzPvFj43co+HYCdc=";
  };

  buildInputs = [ django ];

  propagatedBuildInputs = [ static3 ];

  pythonImportsCheck = [ "dj_static" ];

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Serve production static files with Django";
    homepage = "https://github.com/heroku-python/dj-static";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    description = "Serve production static files with Django";
    homepage = "https://github.com/heroku-python/dj-static";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
