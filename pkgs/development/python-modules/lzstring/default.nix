{
  lib,
  buildPythonPackage,
  fetchPypi,
  future,
}:

buildPythonPackage rec {
  pname = "lzstring";
  version = "1.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gvph5ZgZP7zCEeCJnwmpZ54z+RArzMN/v9oLf+9NnqI=";
  };

  propagatedBuildInputs = [ future ];

  meta = {
    description = "lz-string for python";
    homepage = "https://github.com/gkovacs/lz-string-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
