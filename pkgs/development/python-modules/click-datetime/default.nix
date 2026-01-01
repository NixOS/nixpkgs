{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  click,
}:

buildPythonPackage rec {
  pname = "click-datetime";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "click_datetime";
    inherit version;
    hash = "sha256-nzXtP6sT9VMiHOjFqJXlGF1zYJk8Ud1/hii5tPY2kws=";
  };

  build-system = [ poetry-core ];

  pythonRemoveDeps = [ "wheel" ];

  dependencies = [ click ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "click_datetime" ];

<<<<<<< HEAD
  meta = {
    description = "Datetime type support for click";
    homepage = "https://github.com/click-contrib/click-datetime";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    description = "Datetime type support for click";
    homepage = "https://github.com/click-contrib/click-datetime";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
