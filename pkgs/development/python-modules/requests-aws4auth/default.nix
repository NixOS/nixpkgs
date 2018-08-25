{ lib, buildPythonPackage, fetchPypi, fetchzip, isPy3k, requests }:
with lib;
buildPythonPackage rec {
  pname = "requests-aws4auth";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g52a1pm53aqkc9qb5q1m918c1qy6q47c1qz63p5ilynfbs3m5y9";
  };

  postPatch = optionalString isPy3k ''
    sed "s/path_encoding_style/'path_encoding_style'/" \
      -i requests_aws4auth/service_parameters.py
  '';

  propagatedBuildInputs = [ requests ];

  # The test fail on Python >= 3 because of module import errors.
  doCheck = !isPy3k;

  meta = {
    description = "Amazon Web Services version 4 authentication for the Python Requests library.";
    homepage = https://github.com/sam-washington/requests-aws4auth;
    license = licenses.mit;
    maintainers = [ maintainers.basvandijk ];
  };
}
