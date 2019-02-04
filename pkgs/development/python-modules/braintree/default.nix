{ lib,
  fetchPypi,
  requests,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "braintree";
  version = "3.51.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aavalwxcpql416f0n6wxq2h5jpvbx5jq4y4nz2wsppgjbsxylcc";
  };

  propagatedBuildInputs = [ requests ];

  # pypi release does not include tests
  doCheck = false;

  meta = with lib; {
    description = "Python library for integration with Braintree";
    homepage = https://github.com/braintree/braintree_python;
    license = licenses.mit;
    maintainers = [ maintainers.ivegotasthma ];
  };
}
