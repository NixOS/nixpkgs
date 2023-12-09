{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, pcre
}:

buildPythonPackage rec {
  pname = "pyautocorpus";
  version = "0.1.12";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FGkRsmXrTncenUlRb/ZakaTyVGTjZozqb4iF8tKYrVE=";
  };

  buildInputs = [
    pcre
  ];

  meta = with lib; {
    homepage = "https://github.com/seanmacavaney/pyautocorpus";
    license = licenses.mit;
    description = "A python interface to the AutoCorpus library";
    maintainers = [ maintainers.gm6k ];
  };
}
