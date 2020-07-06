{ lib, buildPythonPackage, fetchPypi, isPy3k, requests }:
with lib;
buildPythonPackage rec {
  pname = "requests-aws4auth";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kjmvfjslv9w7nf33b6gc6dra7c2wj8djxlh4qm4ankbd3zzcl19";
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
    homepage = "https://github.com/sam-washington/requests-aws4auth";
    license = licenses.mit;
    maintainers = [ maintainers.basvandijk ];
  };
}
