{ stdenv
, buildPythonPackage
, fetchgit
, flask
}:

buildPythonPackage rec {
  pname = "github-webhook";
  version = "unstable-2016-03-11";

  # There is a PyPI package but an older one.
  src = fetchgit {
    url = "https://github.com/bloomberg/python-github-webhook.git";
    rev = "ca1855479ee59c4373da5425dbdce08567605d49";
    sha256 = "0mqwig9281iyzbphp1d21a4pqdrf98vs9k8lqpqx6spzgqaczx5f";
  };

  propagatedBuildInputs = [ flask ];
  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A framework for writing webhooks for GitHub";
    license = licenses.mit;
    homepage = https://github.com/bloomberg/python-github-webhook;
  };

}
