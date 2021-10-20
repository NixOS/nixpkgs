{ buildPythonPackage, fetchPypi, lib, pytest, setuptools-scm }:

buildPythonPackage rec {
  pname = "qmk_dotty_dict";
  version = "1.3.0.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-O2EeOTZgv6poNcaOlHhLroD+B7hJCXi17KsDoNL8fqI=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  doCheck = false;

  meta = with lib; {
    description = "Dictionary wrapper for quick access to deeply nested keys";
    homepage = "https://github.com/pawelzny/dotty_dict";
    license = licenses.mit;
    maintainers = with maintainers; [ babariviere ];
  };
}
