# `fetchPypi` function for fetching artifacts from PyPI.
{ fetchurl
, makeOverridable
}:

makeOverridable( {format ? "setuptools", ... } @attrs:
  let
    fetchWheel = {pname, version, sha256, python ? "py2.py3", abi ? "none", platform ? "any"}:
    # Fetch a wheel. By default we fetch an universal wheel.
    # See https://www.python.org/dev/peps/pep-0427/#file-name-convention for details regarding the optional arguments.
      let
        url = "https://files.pythonhosted.org/packages/${python}/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}-${python}-${abi}-${platform}.whl";
      in fetchurl {inherit url sha256;};
    fetchSource = {pname, version, sha256, extension ? "tar.gz"}:
    # Fetch a source tarball.
      let
        url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}.${extension}";
      in fetchurl {inherit url sha256;};
    fetcher = (if format == "wheel" then fetchWheel
      else if format == "setuptools" then fetchSource
      else throw "Unsupported format ${format}");
  in fetcher (builtins.removeAttrs attrs ["format"]) )