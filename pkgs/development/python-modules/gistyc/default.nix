{
  lib,
  buildPythonPackage,
  fetchPypi,
  certifi,
  click,
  requests,
}:

buildPythonPackage rec {
  pname = "gistyc";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WVK45U9e3qyZFi9wSRHNi9+1u4TetlZkYXAZN7LVqhE=";
  };

  propagatedBuildInputs = [
    certifi
    click
    requests
  ];

  pythonImportsCheck = [ "gistyc" ];

  meta = with lib; {
    homepage = "https://github.com/ThomasAlbin/gistyc";
    description = "Python based GitHub GIST management tool";
    longDescription = ''
      gistyc is a Python-based library that enables developers to create, update
      and delete their GitHub GISTs. CLI capabilities allow you to execute the
      routines from the shell and can be integrated into your project's CI/CD
      pipeline to automatically create or update your GISTs (e.g., via GitHub
      actions). Files are separated in GIST sections depending on the separation
      blocks.
    '';
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
