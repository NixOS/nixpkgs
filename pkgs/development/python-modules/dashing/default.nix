{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  blessed,
}:

buildPythonPackage rec {
  pname = "dashing";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JRRgjg8pp3Xb0bERFWEhnOg9U8+kuqL+QQH6uE/Vbxs=";
  };

  propagatedBuildInputs = [ blessed ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/FedericoCeratto/dashing";
    description = "Terminal dashboards for Python";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ juliusrickert ];
=======
  meta = with lib; {
    homepage = "https://github.com/FedericoCeratto/dashing";
    description = "Terminal dashboards for Python";
    license = licenses.gpl3;
    maintainers = with maintainers; [ juliusrickert ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
