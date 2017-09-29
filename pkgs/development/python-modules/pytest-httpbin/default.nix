{ buildPythonPackage
, lib
, fetchFromGitHub
, pytest
, flask
, decorator
, httpbin
, six
, requests
}:

buildPythonPackage rec {
  pname = "pytest-httpbin";
  name = "${pname}-${version}";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "kevin1024";
    repo = "pytest-httpbin";
    rev = "v${version}";
    sha256 = "0j3n12jjy8cm0va8859wqra6abfyajrgh2qj8bhcngf3a72zl9ks";
  };

  checkPhase = ''
    py.test -k "not test_chunked_encoding"
  '';

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ flask decorator httpbin six requests ];

  meta = {
    description = "Easily test your HTTP library against a local copy of httpbin.org";
    homepage = https://github.com/kevin1024/pytest-httpbin;
    license = lib.licenses.mit;
  };
}

