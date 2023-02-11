{ lib, buildPythonPackage, fetchPypi, markdown,
  pytest, pytest-runner, pytest-cov, coverage }:

buildPythonPackage rec {
  pname = "MarkdownSuperscript";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c255b5959c1f5dd364ae80762bd0a568a0fcc9fd4e4a3d7e7b192e88adf8900";
  };

  propagatedBuildInputs = [ markdown ];

  postPatch = ''
    # remove version bounds for Markdown dependency
    sed 's/\["Markdown.*"\]/["Markdown"]/' -i setup.py

    # remove version bounds for test dependencies
    sed 's/=.*//' -i requirements/*.txt
  '';

  nativeCheckInputs = [ pytest pytest-runner pytest-cov coverage ];

  meta = with lib; {
    description = "An extension to the Python Markdown package enabling superscript text";
    homepage = "https://github.com/jambonrose/markdown_superscript_extension";
    license = licenses.bsd2;
    broken = true; # unmaintained in nixpkgs, barely maintained in pypi, added 2020-11-29
  };
}
