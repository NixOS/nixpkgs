{
  lib,
  buildPythonPackage,
  fetchPypi,
  unidecode,
  regex,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "awesome-slugify";
  version = "1.6.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u97D+iGHkXRzou+tCStX9xJaVfhBp89qF3MXjTLM/XE=";
  };

  prePatch = ''
    substituteInPlace setup.py \
        --replace 'Unidecode>=0.04.14,<0.05' 'Unidecode>=0.04.14'
  '';

  patches = [
    ./slugify_filename_test.patch # fixes broken test by new unidecode
  ];

  propagatedBuildInputs = [
    unidecode
    regex
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/dimka665/awesome-slugify";
    description = "Python flexible slugify function";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
