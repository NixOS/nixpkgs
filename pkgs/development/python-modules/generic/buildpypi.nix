/* This function wraps buildPythonPackage and uses pre-fetched data from PyPI to build a package.
*/
{ buildPythonPackage
, pypi-sources
, fetchurl
}:

{ name
, version ? ""
, ... } @ attrs:

let
  # Whether to actually use PyPI
  pypi = !(builtins.hasAttr "src" attrs || builtins.hasAttr "srcs" attrs);

  # Use Meta data from PyPI
  pypimeta = if pypi then pypi-sources.${name}.meta else {};

  # Version. When specified, use that.
  # Otherwise, if src is not given and there is a PyPI source available, then use the latest version available.
  version = attrs.version or (if pypi && builtins.hasAttr name pypi-sources then pypi-sources.${name}.latest_version else "");
  # Use src if given. Otherwise, pick the right version via PyPI.
  src = attrs.src or attrs.srcs or (fetchurl pypi-sources.${name}.versions.${version});

in buildPythonPackage ( attrs // {name = name + "-" + version; src=src; meta = pypimeta // attrs.meta;} )
