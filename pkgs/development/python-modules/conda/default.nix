{ lib
, buildPythonPackage
, fetchPypi
, pycosat
, requests
, ruamel_yaml
, isPy3k
, enum34
}:

# Note: this installs conda as a library. The application cannot be used.
# This is likely therefore NOT what you're looking for.

buildPythonPackage rec {
  pname = "conda";
  version = "4.3.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a91ef821343dea3ba9670f3d10b36c1ace4f4c36d70c175d8fc8886e94285953";
  };

  propagatedBuildInputs = [ pycosat requests ruamel_yaml ] ++ lib.optional (!isPy3k) enum34;

  # No tests
  doCheck = false;

  meta = {
    description = "OS-agnostic, system-level binary package manager";
    homepage = "https://github.com/conda/conda";
    license = lib.licenses.bsd3;
  };

}
