{ lib
, isPy3k
, fetchPypi
, buildPythonPackage }:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "0.7.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "18z6hqfnfjqnrcgfgl5pkj9ggf9yx0yyy94azcn1qf7hqn6g3l14";
  };

  meta = with lib; {
    description = "A fast, extensible Markdown parser in pure Python.";
    homepage = "https://github.com/miyuchina/mistletoe";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
