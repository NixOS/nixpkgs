{ lib, buildPythonPackage, fetchPypi, isPy3k, requests }:
with lib;
buildPythonPackage rec {
  pname = "requests-aws4auth";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2950f6ff686b5a452a269076d990e4821d959b61cfac319c3d3c6daaa5db55ce";
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
