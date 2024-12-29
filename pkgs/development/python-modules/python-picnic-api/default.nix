{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "python-picnic-api";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1axqw4bs3wa9mdac35h7r25v3i5g7v55cvyy48c4sg31dxnr4wcp";
  };

  propagatedBuildInputs = [ requests ];

  # Project doesn't ship tests
  # https://github.com/MikeBrink/python-picnic-api/issues/13
  doCheck = false;

  pythonImportsCheck = [ "python_picnic_api" ];

  meta = with lib; {
    description = "Python wrapper for the Picnic API";
    homepage = "https://github.com/MikeBrink/python-picnic-api";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
