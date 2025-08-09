{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "pymorphy3-dicts-uk";
  version = "2.4.1.1.1663094765";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s5RaNBNuGTgGzeZXuicdiKYHYedRN8E9E4qNFCqNEqw=";
  };

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pymorphy3_dicts_uk" ];

  meta = with lib; {
    description = "Ukrainian dictionaries for pymorphy3";
    homepage = "https://github.com/no-plagiarism/pymorphy3-dicts";
    license = licenses.mit;
    maintainers = with maintainers; [ jboy ];
  };
}
