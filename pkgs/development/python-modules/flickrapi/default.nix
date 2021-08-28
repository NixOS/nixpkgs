{ lib
, buildPythonPackage
, fetchPypi
, requests
, requests_toolbelt
, requests_oauthlib
, pytest
, pytestrunner
, pytestcov
, responses
}:

buildPythonPackage rec {
  pname   = "flickrapi";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03g2z21k6nhxgwysjrgnxj9m1yg25mnnkr10gpyfhfkd9w77pcpz";
  };

  propagatedBuildInputs = [ requests requests_toolbelt requests_oauthlib ];

  checkInputs = [ pytest pytestrunner pytestcov responses ];
  doCheck = false; # Otherwise:
  # ========================= no tests ran in 0.01 seconds =========================
  # builder for '/nix/store/c8a58v6aa18zci08q2l53s12ywn8jqhq-python3.6-flickrapi-2.4.0.drv' failed with exit code 5

  meta = {
    description = "A Python interface to the Flickr API";
    homepage    = "https://stuvel.eu/flickrapi";
    license     = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
