{ buildPythonPackage, fetchPypi, lib, setuptools-scm }:

buildPythonPackage rec {
  pname = "qmk_dotty_dict";
  version = "1.3.0.post1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O2EeOTZgv6poNcaOlHhLroD+B7hJCXi17KsDoNL8fqI=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pawelzny/dotty_dict";
    description = "Dictionary wrapper for quick access to deeply nested keys";
    longDescription = ''
      This is a version of dotty-dict by QMK (https://qmk.fm) since the original
      dotty-dict published to pypi has non-ASCII characters that breaks with
      some non-UTF8 locale settings.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ babariviere ];
  };
}
